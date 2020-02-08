part of 'search_queue_bloc.dart';

abstract class SearchQueueEvent extends Equatable {
  const SearchQueueEvent();
}

class AddToSearchQueue extends SearchQueueEvent {
  final SearchEvent event;

  const AddToSearchQueue(this.event);

  @override
  List<Object> get props => [event];

  @override
  String toString() {
    return 'AddToSearchQueue { event: $event }';
  }
}

class SearchQueueCleared extends SearchQueueEvent {
  const SearchQueueCleared();

  @override
  List<Object> get props => [];
}