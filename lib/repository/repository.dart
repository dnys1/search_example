import 'package:meta/meta.dart';

import 'query_response.dart';

/// The number of results per page.
final int kPageSize = 20;

abstract class Repository {
  Future<QueryResponse> getSearchResults({
    @required String query,
    @required int page,
    List<String> results,
  });
}