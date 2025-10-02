extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    return cast<T?>().firstWhere(test as bool Function(T?), orElse: () => null);
  }
}
