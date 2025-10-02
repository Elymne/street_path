import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format() {
    return DateFormat("d MMMM y", "fr_FR").format(this);
  }
}
