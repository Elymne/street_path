import 'package:logger/logger.dart';

class SpLog {
  late final Logger _logger;

  static final SpLog instance = SpLog._private();
  SpLog._private() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: null,
        errorMethodCount: null,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  void t(String message) {
    _logger.t(message);
  }

  void i(String message) {
    _logger.i(message);
  }

  void w(String message) {
    _logger.w(message);
  }

  void e(String message, Object error, {StackTrace? stack}) {
    if (stack == null) {
      _logger.e(message, error: error);
      return;
    }
    _logger.f(message, error: error, stackTrace: stack);
  }

  void d(String message) {
    _logger.d(message);
  }
}
