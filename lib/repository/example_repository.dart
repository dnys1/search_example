import 'package:meta/meta.dart';
import 'package:search_example/models/query_response.dart';
import 'package:search_example/repository/repository.dart';

class ExampleRepository implements Repository {
  @override
  Future<QueryResponse> getSearchResults({
    @required String query,
    @required int page,
    List<String> results,
  }) async {
    assert(query != null && query.isNotEmpty);
    assert(page != null && page >= 0);

    print('Loading page $page');

    // Wait for the "server response"
    await Future.delayed(const Duration(seconds: 1));

    // The kind of data that comes back from Algolia,
    // for example.
    final serverResponse = {
      'numResults': 100,
      'numPages': 5,
      // Generate sequential results, just for demo purposes.
      'hits': List<String>.generate(Repository.pageSize,
          (index) => '${index + Repository.pageSize * page + 1}'),
    };

    final int numResults = serverResponse['numResults'];
    final int numPages = serverResponse['numPages'];
    final List<String> hits = serverResponse['hits'];

    // This is our first call to the server.
    // In later calls, we will pass the results
    // list and add to it.
    if (results == null) {
      assert(page == 0);

      // Create a fixed-length list with the number
      // of results we have.
      results = List<String>(numResults);
    }

    // Instead of appending to the list, insert at the
    // correct offset. This allows loading pages out of
    // order.
    int startIndex = page * Repository.pageSize;
    int currIndex = startIndex;
    for (String hit in hits) {
      results[currIndex] = hit;
      currIndex++;
    }

    return QueryResponse(
      results: results,
      numPages: numPages,
      numResults: numResults,
    );
  }
}
