abstract class StreetPathGateway {
  Future init();
  Future start({String notificationTitle, String notificationText});
  Future stop();
  Future<StreetPathStatus> getStatus();
}

enum StreetPathStatus { none, working, cancel }
