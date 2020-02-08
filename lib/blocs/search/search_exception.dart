class SearchException implements Exception {
  final String message;

  const SearchException(this.message);

  factory SearchException.unknown() =>
      const SearchException('An unknown error has occurred.');

  @override
  String toString() {
    return message;
  }
}
