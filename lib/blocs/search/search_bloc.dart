import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:search_example/repository/repository.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Repository _repository;
  final Queue searchQueue = Queue<SearchEvent>();

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
      yield* _mapLoadSearchTermToState(event.query);
    } else if (event is SearchPageRequested) {
      yield* _mapLoadNextPageToState(page: event.page);
    } else if (event is SearchCleared) {
      yield* _mapClearSearchTermToState();
    }
  }

  Stream<SearchState> _mapLoadSearchTermToState(String query) async* {
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

  Stream<SearchState> _mapLoadNextPageToState({@required int page}) async* {
    // Make sure we've loaded one page already and there are more results to load.
    if (state is SearchSuccess && (state as SearchSuccess).canLoadMore) {
      var _results = (state as SearchSuccess).results;
      yield SearchPageLoadInProgress.fromState(state, page);
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

  Stream<SearchState> _mapClearSearchTermToState() async* {
    yield SearchInitial();
  }
}
