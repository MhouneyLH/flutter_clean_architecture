import 'package:internet_connection_checker/internet_connection_checker.dart';

// important as encapsulation of the packages used (here: internet_connection_checker)
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  // no async await needed, as Future is returned
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
