import 'package:meta/meta.dart';
import 'package:search_example/models/query_response.dart';

abstract class Repository {
  static final int pageSize = 20;
  
  Future<QueryResponse> getSearchResults({
    @required String query,
    @required int page,
    List<String> results,
  });
}