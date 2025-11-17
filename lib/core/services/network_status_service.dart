import 'package:flutter/foundation.dart';

class NetworkStatusService extends ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  void _setStatus(bool value) {
    if (_isOnline != value) {
      _isOnline = value;
      notifyListeners();
    }
  }

  void setOffline() {
    _setStatus(false);
  }

  void setOnlineStatus() {
    _setStatus(true);
  }
}
