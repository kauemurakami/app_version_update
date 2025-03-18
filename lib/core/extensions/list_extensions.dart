/// An extension on [List] that provides a safe way to get an element at the
/// specified [index], returning a [defaultValue] if the index is out of bounds.
///
/// Example usage:
/// ```dart
/// List<int> numbers = [1, 2, 3];
/// int value = numbers.getOrDefault(2, 0); // Returns 3
/// int defaultValue = numbers.getOrDefault(5, 0); // Returns 0 (default)
/// ```
extension ListExtensions<T> on List<T> {
  /// Returns the element at the specified [index], or [defaultValue] if the
  /// index is out of bounds.
  ///
  /// If the [index] is negative or greater than or equal to the length of the list,
  /// the [defaultValue] is returned instead of throwing an [IndexOutOfRange] error.
  ///
  /// [index] - The index of the element to retrieve.
  /// [defaultValue] - The value to return if the index is out of bounds.
  ///
  /// Returns the element at [index] if valid, otherwise [defaultValue].
  T getOrDefault(int index, T defaultValue) {
    if (index < 0 || index >= length) {
      return defaultValue;
    }
    return this[index];
  }
}
