import 'dart:ui';
import 'package:db_sqlite/utils/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:db_sqlite/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> inicializarFirebase() async {
  // Inicializa o Firebase com as opções da plataforma atual
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Captura erros do Flutter e envia para o Crashlytics
  FlutterError.onError = (errorDetails) {
    LoggerService.logFlutterError(errorDetails);
  };

  // Captura erros fora do Flutter (ex: erros nativos) e envia para o Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerService.logError(error, stack);
    return true;
  };
}

void inicializarDesktopDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
