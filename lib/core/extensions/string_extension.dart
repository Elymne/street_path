extension StringExtension on String {
  String toName() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
