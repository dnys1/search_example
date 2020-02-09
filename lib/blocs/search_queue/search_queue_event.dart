part of 'search_queue_bloc.dart';

abstract class SearchQueueEvent extends Equatable {
  const SearchQueueEvent();
}

class SearchQueuePageRequested extends SearchQueueEvent {
  final SearchEvent event;

  const SearchQueuePageRequested(this.event);

  @override
  List<Object> get props => [event];

  @override
  String toString() {
    return 'SearchQueuePageRequested { event: $event }';
  }
}

class SearchQueueCleared extends SearchQueueEvent {
  const SearchQueueCleared();

  @override
  List<Object> get props => [];
}