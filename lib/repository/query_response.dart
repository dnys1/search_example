import 'package:meta/meta.dart';

class QueryResponse {
  final List<String> results;
  final int numPages;
  final int numResults;

  const QueryResponse({
    @required this.results,
    @required this.numPages,
    @required this.numResults,
  });
}