import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServices {
  final Connectivity _connectivity = Connectivity();
  Stream<bool> checkConnectivity() {
    return _connectivity.onConnectivityChanged.map((
      List<ConnectivityResult> connectivity,
    ) {
      bool isConnected = connectivity.contains(ConnectivityResult.mobile) ||
          connectivity.contains(ConnectivityResult.wifi);
      print('Connectivity changed: $connectivity, isConnected: $isConnected');
      return isConnected;
    });
  }
}
