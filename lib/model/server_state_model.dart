enum ServerStatus {
  online,
  offline,
  connecting,
  error,
}

extension ServerStatusExtension on ServerStatus {
  String get toMessage {
    switch (this) {
      case ServerStatus.online:
        return "status.server.online";
      case ServerStatus.offline:
        return "status.server.offline";
      case ServerStatus.connecting:
        return "status.server.connecting";
      case ServerStatus.error:
        return "status.server.error";
    }
  }
}
