import 'package:meta/meta.dart';
import 'package:search_example/repository/repository.dart';

import 'query_response.dart';

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

    // @begin mock_server_code
    // Wait for the "server response"
    await Future.delayed(const Duration(seconds: 1));

    // The kind of data that comes back from Algolia,
    // for example.
    final serverResponse = {
      'numResults': 100,
      'numPages': 5,
      // Generate sequential results for demo purposes.
      'hits': List<String>.generate(
        kPageSize,
        (index) => '${index + kPageSize * page + 1}',
      ),
    };
    // @end mock_server_code

    final int numResults = serverResponse['numResults'];
    final int numPages = serverResponse['numPages'];
    final List<String> hits = serverResponse['hits'];

    // If this is our first call to the server,
    // `results` will be null. In later calls, we 
    // will pass the results list and add to it.
    // This allows us to maintain a fixed-length list
    // which serves multiple purposes, primarily
    // so that our GridView will not be updating its
    // length ever and we can insert objects at their
    // correct location in the list, allowing for loading
    // pages out of order, which may happen if a page
    // request finishes before the previous.
    if (results == null) {
      assert(page == 0);

      // Create a fixed-length list with the number
      // of results we have.
      results = List<String>(numResults);
    }

    // Instead of appending to the list, insert at the
    // correct offset. This allows loading pages out of
    // order.
    int startIndex = page * kPageSize;
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
