// Importações nativas do Dart
import 'dart:io';

import 'package:db_sqlite/data/interface/finan_categoria_dao_impl.dart';
import 'package:db_sqlite/data/interface/finan_lancamento_dao_impl.dart';
import 'package:db_sqlite/data/interface/finan_tipo_dao_impl.dart';
import 'package:db_sqlite/data/interface/usuario_dao_impl.dart';
// Importações do projeto e pacotes externos
import 'package:db_sqlite/data/seed.dart';
import 'package:db_sqlite/main_app.dart';
import 'package:db_sqlite/data/service/auth_service.dart';
import 'package:db_sqlite/data/service/finan_categoria_service.dart';
import 'package:db_sqlite/data/service/finan_lancamento_service.dart';
import 'package:db_sqlite/data/service/finan_tipo_service.dart';
import 'package:db_sqlite/data/service/usuario_service.dart';
import 'package:db_sqlite/util/inicializacao.dart';
import 'package:db_sqlite/ui/viewmodel/auth_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/conectividade_check_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/finan_categoria_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/finan_lancamento_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/finan_tipo_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/trocar_tema_viewmodel.dart';
import 'package:db_sqlite/ui/viewmodel/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create:
              (_) => AuthViewModel(
                authService: AuthService(
                  usuarioDao: UsuarioDaoImpl(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => UsuarioViewModel(
                service: UsuarioService(
                  dao: UsuarioDaoImpl(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FinanTipoViewModel(
                service: FinanTipoService(
                  dao: FinanTipoDaoImpl(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FinanCategoriaViewModel(
                service: FinanCategoriaService(
                  dao: FinanCategoriaDaoImpl(),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FinanLancamentoViewModel(
                service: FinanLancamentoService(
                  dao: FinanLancamentoDaoImpl(),
                ),
              ),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
        ChangeNotifierProvider(create: (_) => TrocarTemaViewModel()),
      ],
      // Chamada da tela inicial da aplicação
      child: Aplicacao(),
    ),
  );
}
