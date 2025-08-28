import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityViewModel with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  String _connectionStatus = 'Verificando...';
  String get connectionStatus => _connectionStatus;

  ConnectivityViewModel() {
    _init();
  }

  void _init() async {
    await _updateInitialStatus();

    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.last : ConnectivityResult.none;
      _updateConnectionStatusFrom(result);
    });
  }

  Future<void> _updateInitialStatus() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final ConnectivityResult result = results.isNotEmpty ? results.last : ConnectivityResult.none;
    await _updateConnectionStatusFrom(result);
  }

  Future<void> _updateConnectionStatusFrom(ConnectivityResult result) async {
    String status;

    switch (result) {
      case ConnectivityResult.mobile:
        status = 'Rede móvel';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.ethernet:
        status = 'Ethernet';
        break;
      case ConnectivityResult.vpn:
        status = 'VPN';
        break;
      case ConnectivityResult.none:
        status = 'Sem rede';
        break;
      default:
        status = 'Desconhecido';
    }

    bool hasInternet = await _checkInternetAccess();

    // _connectionStatus = '$status | Internet: ${hasInternet ? "SIM" : "NÃO"}';
    final newStatus = '$status | Internet: ${hasInternet ? "SIM" : "NÃO"}';

    if (newStatus != _connectionStatus) {  // só notifica se mudar
    _connectionStatus = newStatus;
    notifyListeners();
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
