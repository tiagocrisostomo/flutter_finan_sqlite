// Importações nativas do Dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importações do projeto e pacotes externos
import 'package:db_sqlite/database/seed.dart';
import 'package:db_sqlite/main_app.dart';
import 'package:db_sqlite/utils/inicializacao.dart';
import 'package:db_sqlite/viewmodel/auth_viewmodel.dart';
import 'package:db_sqlite/viewmodel/conectividade_check_viewmodel.dart';
import 'package:db_sqlite/viewmodel/finan_categoria_viewmodel.dart';
import 'package:db_sqlite/viewmodel/finan_lancamento_viewmodel.dart';
import 'package:db_sqlite/viewmodel/finan_tipo_viewmodel.dart';
import 'package:db_sqlite/viewmodel/trocar_tema_viewmodel.dart';
import 'package:db_sqlite/viewmodel/usuario_viewmodel.dart';

/// Função principal do app
void main() async {
  // Garante que os bindings do Flutter estejam inicializados antes de usar recursos async
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialização específica para plataformas mobile
  if (Platform.isAndroid || Platform.isIOS) {
    await inicializarFirebase();
  }
  // Inicialização específica para desktop (Linux, Windows, macOS)
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Inicializa suporte ao sqflite_ffi (para uso de SQLite em desktop)
    inicializarDesktopDatabase();
  }
  // Popula o banco com dados iniciais (caso necessário)
  await inicializarBancoComDadosPadrao();
  // Inicializa o app com os providers e configurações do MaterialApp
  runApp(
    MultiProvider(
      providers: [
        // Providers responsáveis pelo gerenciamento de estado das ViewModels
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioViewModel()),
        ChangeNotifierProvider(create: (_) => FinanTipoViewModel()),
        ChangeNotifierProvider(create: (_) => FinanCategoriaViewModel()),
        ChangeNotifierProvider(create: (_) => FinanLancamentoViewModel()),
        ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
        ChangeNotifierProvider(create: (_) => TrocarTemaViewModel()),
      ],
      // Chamada da tela inicial da aplicação
      child: Aplicacao(),
    ),
  );
}
