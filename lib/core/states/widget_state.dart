/// Structure of any data from providers used in this application.
abstract class WidgetState {
  final WidgetStatus status;

  WidgetState({required this.status});
}

/// Init : Default state of a provider value.
/// Loading : When provider value is working.
/// Success : When data has been fetched succefully.
/// Failure : When something from the app has catch an error known by developper (for example, a client input error).
enum WidgetStatus { init, loading, success, failure }
