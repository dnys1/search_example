import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/blocs/search/bloc.dart';
import 'package:search_example/blocs/search_queue/search_queue_bloc.dart';
import 'package:search_example/repository/repository.dart';

class SearchBody extends StatefulWidget {
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  void _loadPage(int page) {
    var state = BlocProvider.of<SearchBloc>(context).state;
    var queue = BlocProvider.of<SearchQueueBloc>(context).state;
    if (state is SearchSuccess && state.canLoadMore) {
      // If already loading this page, don't put in queue.
      if (state is SearchPageLoadInProgress && state.page == page) {
        return;
        // If it's already in the queue, don't put in queue.
      } else if (!queue.contains(SearchPageRequested(page))) {
        BlocProvider.of<SearchQueueBloc>(context)
            .add(AddToSearchQueue(SearchPageRequested(page)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        var state = BlocProvider.of<SearchBloc>(context).state as SearchSuccess;
        var results = state.results;
        return OrientationBuilder(
          builder: (context, orientation) {
            var crossAxisCount;
            switch (orientation) {
              case Orientation.portrait:
                crossAxisCount = 2;
                break;
              case Orientation.landscape:
                crossAxisCount = 3;
                break;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount),
              itemBuilder: (context, index) {
                String result = results[index];
                if (result == null) {
                  if (index % Repository.pageSize == 0) {
                    _loadPage((index / Repository.pageSize).floor());
                  }
                  return Card(
                    key: Key('card-$index'),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Card(
                    key: Key('card-$index'),
                    child: Center(
                      child: Text(
                        result,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  );
                }
              },
              itemCount: state.numResults,
            );
          },
        );
      },
    );
  }
}
