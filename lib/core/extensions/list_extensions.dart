extension ListExtensions<T> on List<T> {
  T getOrDefault(int index, T defaultValue) {
    if (index < 0 || index >= length) {
      return defaultValue;
    }
    return this[index];
  }
}
