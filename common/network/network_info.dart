import 'package:connectivity/connectivity.dart';
import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;
  bool networkReliably = false;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    final isConnectedWithMobile = result == ConnectivityResult.mobile;
    final isConnectedWithWifi = result == ConnectivityResult.wifi;

    if (isConnectedWithMobile || isConnectedWithWifi) {
      var res = await InternetAddress.lookup("google.com");

      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        networkReliably = false;
      } else {
        networkReliably = true;
      }
      return networkReliably;
    } else
      return true;
  }
}
