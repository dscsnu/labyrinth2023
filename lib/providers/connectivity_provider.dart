import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen(
      (event) {
        _connectivityStatus = event;
        notifyListeners();
      },
    );
  }

  ConnectivityResult get connectivityStatus => _connectivityStatus;
}
