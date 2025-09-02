import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LoggerService {
  /// Define o identificador do usuário nos relatórios do Crashlytics
  static Future<void> setUserIdentifier(String userIdentifier) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userIdentifier);
    if (kDebugMode) {
      print('[USER IDENTIFIER] $userIdentifier');
    }
  }

  /// Envia mensagens informativas para o Crashlytics
  static Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
    if (kDebugMode) {
      print('[LOG] $message');
    }
  }

  /// Registra erros
  static Future<void> logError(Object error, StackTrace? stack, {information = const [], String? reason, bool? fatal}) async {
    await setUserIdentifier('NOME DO USUARIO');
    FirebaseCrashlytics.instance.recordError(error, stack, reason: reason, fatal: false);
    // await _enviarMensagemDiscord(error, stack, reason: reason, information: information, fatal: false);
    if (kDebugMode) {
      print('[ERROR] $reason\n$error\n$stack');
    }
  }

  /// Registra erros específicos do Flutter (widget tree)
  static Future<void> logFlutterError(FlutterErrorDetails errorDetails) async {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // await _enviarMensagemDiscordDetalhes(errorDetails);
    if (kDebugMode) {
      print('[FLUTTER ERROR] ${errorDetails.exception}');
    }
  }

  /// Envia o erro simples para o webhook do discord
  //   static Future<void> _enviarMensagemDiscord(
  //     dynamic exception,
  //     StackTrace? stack, {
  //     String? reason,
  //     Iterable<Object> information = const [],
  //     bool fatal = false,
  //     String? identifier,
  //   }) async {
  //     const String webhookUrl = 'https://discord.com/api/webhooks/1402621810767302656/CLxDTXrIASCzU2NRTkkDauAlhM81wB0WiXDHEyk2STIiJUBXk0CLt29uScalY_Ul0EaL';

  //     final String mensagem = '''
  // 🔴🔴🔴🔴🔴🔴🔴
  // **Exceção:** $exception
  // **Razão:** $reason
  // **Informações:** ${information.join('\n')}
  // **Stack Trace:** $stack
  // **Fatal:** $fatal
  // **Identificador:$identifier''';

  //     final response = await http.post(Uri.parse(webhookUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'content': mensagem}));

  //     if (response.statusCode == 204) {
  //       debugPrint('Mensagem enviada com sucesso!');
  //     } else {
  //       debugPrint('Erro ao enviar mensagem: ${response.statusCode}');
  //       debugPrint(response.body);
  //     }
  //   }

  /// Envia o erro simples para o webhook do discord
  //   static Future<void> _enviarMensagemDiscordDetalhes(dynamic datalhes) async {
  //     const String webhookUrl = 'https://discord.com/api/webhooks/1402621810767302656/CLxDTXrIASCzU2NRTkkDauAlhM81wB0WiXDHEyk2STIiJUBXk0CLt29uScalY_Ul0EaL';

  //     final String mensagem = '''
  // 🔴🔴🔴🔴🔴🔴🔴
  // **Detalhes:** $datalhes
  // ''';

  //     final response = await http.post(Uri.parse(webhookUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'content': mensagem}));

  //     if (response.statusCode == 204) {
  //       debugPrint('Mensagem enviada com sucesso!');
  //     } else {
  //       debugPrint('Erro ao enviar mensagem: ${response.statusCode}');
  //       debugPrint(response.body);
  //     }
  //   }
}
