import 'package:flutter/material.dart';

class TrocarTemaViewModel extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get temaAtual => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void trocarTema() {
    _isDarkTheme = !_isDarkTheme;
    debugPrint("essa merda ta trocando: ${temaAtual.toString()}");
    notifyListeners();
  }
}
