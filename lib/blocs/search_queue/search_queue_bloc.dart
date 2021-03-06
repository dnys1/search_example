import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:search_example/blocs/search/search_bloc.dart';

part 'search_queue_event.dart';

class SearchQueueBloc extends Bloc<SearchQueueEvent, Queue<SearchEvent>> {
  final SearchBloc _searchBloc;
  StreamSubscription _searchSubscription;

  SearchQueueBloc({@required SearchBloc searchBloc})
      : assert(searchBloc != null),
        _searchBloc = searchBloc {
    _searchSubscription = _searchBloc.listen((searchState) {
      // Add the event once SearchBloc has completed the last request
      if (searchState is SearchSuccess && state.isNotEmpty) {
        _searchBloc.add(state.removeFirst());
      }
      // If the search term is cleared while there are items in the queue,
      // clear the queue to stop all pending search transactions.
      if (searchState is SearchInitial) {
        this.add(SearchQueueCleared());
      }
    });
  }

  @override
  Future<void> close() {
    _searchSubscription.cancel();
    return super.close();
  }

  @override
  Queue<SearchEvent> get initialState => Queue<SearchEvent>();

  @override
  Stream<Queue<SearchEvent>> mapEventToState(
    SearchQueueEvent event,
  ) async* {
    if (event is SearchQueuePageRequested) {
      // If a page is currently loading
      if (_searchBloc.state is SearchPageLoadInProgress) {
        // Add the event to the queue if it's not present already.
        if (!state.contains(event.event)) {
          yield state..addLast(event.event);
        }
      // Otherwise, just load the page.
      } else {
        _searchBloc.add(event.event);
      }
    } else if (event is SearchQueueCleared) {
      yield state..clear();
    }
  }
}
