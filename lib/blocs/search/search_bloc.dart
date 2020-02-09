import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:search_example/repository/repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Repository _repository;

  SearchBloc({
    @required Repository repository,
  })  : assert(repository != null),
        _repository = repository;

  @override
  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      yield* _mapSearchStartedToState(event.query);
    } else if (event is SearchPageRequested) {
      yield* _mapSearchPageRequestedToState(page: event.page);
    } else if (event is SearchCleared) {
      yield* _mapSearchClearedToState();
    }
  }

  Stream<SearchState> _mapSearchStartedToState(String query) async* {
    yield SearchInProgress();
    try {
      var resp =
          await _repository.getSearchResults(query: query, page: 0);
      yield SearchSuccess(
        query: query,
        page: 0,
        results: resp.results,
        numResults: resp.numResults,
        numPages: resp.numPages,
      );
    } catch (e) {
      yield SearchFailure(e.toString());
    }
  }

  Stream<SearchState> _mapSearchPageRequestedToState({@required int page}) async* {
    // Make sure we've loaded one page already and there are more results to load.
    if (state is SearchSuccess && (state as SearchSuccess).canLoadMore) {
      var _results = (state as SearchSuccess).results;
      yield SearchPageLoadInProgress.fromStateAndPage(state, page);
      try {
        final String query = (state as SearchSuccess).query;
        var resp = await _repository.getSearchResults(
          query: query,
          page: page,
          results: _results,
        );
        yield SearchSuccess(
          query: query,
          page: page,
          results: resp.results,
          numPages: resp.numPages,
          numResults: resp.numResults,
        );
      } catch (e) {
        yield SearchFailure(e.toString());
      }
    }
  }

  Stream<SearchState> _mapSearchClearedToState() async* {
    yield SearchInitial();
  }
}
