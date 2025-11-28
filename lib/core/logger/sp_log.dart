import 'package:logger/logger.dart';

class SpLog {
  // todo: bof.
  bool _activated = true;
  void setActivated(bool activated) => _activated = activated;

  SpLog._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: null,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  static final SpLog _instance = SpLog._internal();

  factory SpLog() {
    return _instance;
  }

  late final Logger _logger;

  void t(String message) {
    if (!_activated) return;
    _logger.t(message);
  }

  void i(String message) {
    if (!_activated) return;
    _logger.i(message);
  }

  void w(String message) {
    if (!_activated) return;
    _logger.w(message);
  }

  void e(String message, Object error, {StackTrace? stack}) {
    if (!_activated) return;
    if (stack == null) {
      _logger.e(message, error: error);
      return;
    }
    _logger.f(message, error: error, stackTrace: stack);
  }

  void d(String message) {
    if (!_activated) return;
    _logger.d(message);
  }
}
