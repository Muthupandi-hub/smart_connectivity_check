import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'internet_probe.dart';

class SmartConnectivity {
  static final _connectivity = Connectivity();
  static final _controller = StreamController<bool>.broadcast();

  static Stream<bool> get onStatusChange => _controller.stream;

  static Future<bool> checkNow() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;
    return InternetProbe.hasInternet();
  }

  static void initialize() {
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        _controller.add(false);
      } else {
        _controller.add(await InternetProbe.hasInternet());
      }
    });
  }

  static void dispose() {
    _controller.close();
  }
}
