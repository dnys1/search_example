part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchInProgress extends SearchState {
  const SearchInProgress();
}

class SearchSuccess extends SearchState {
  final String query;

  /// 0-indexed value for the current page.
  final int page;

  /// 1-indexed value for the number of pages.
  final int numPages;
  final int numResults;
  final List<String> results;

  const SearchSuccess({
    @required this.query,
    @required this.results,
    @required this.page,
    @required this.numPages,
    @required this.numResults,
  });

  /// Whether or not there are more pages to load based off
  /// the current `page` and server-provided `numPages`.
  /// `page` is 0-indexed while `numPages` is 1-indexed.
  bool get canLoadMore => page + 1 < numPages;

  @override
  List<Object> get props =>
      [query, page, numPages, numResults, results];

  @override
  String toString() {
    return 'SearchSuccess { query: $query, page: ${page + 1}, numPages: $numPages, count: ${results.length} }';
  }
}

class SearchPageLoadInProgress extends SearchSuccess {
  SearchPageLoadInProgress.fromStateAndPage(SearchSuccess state, int page)
      : super(
          results: state.results,
          numPages: state.numPages,
          numResults: state.numResults,
          query: state.query,
          page: page,
        );

  @override
  String toString() {
    return 'SearchPageLoadInProgress { page: ${page + 1} }';
  }
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure(this.message);

  factory SearchFailure.unknown() =>
      SearchFailure('An unknown error has occurred.');

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'SearchFailure { message: $message }';
  }
}
