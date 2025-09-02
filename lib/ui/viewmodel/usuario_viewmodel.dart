import 'dart:io';

import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/data/service/usuario_service.dart';
import 'package:db_sqlite/util/logger_service.dart';
import 'package:flutter/material.dart';

enum EstadoUsuario {
  inicial,
  carregando,
  carregado,
  erro,
  deletando,
  deletado,
  incluindo,
  incluido,
  alterando,
  alterado,
}

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioService _service;

  UsuarioViewModel({required UsuarioService service}) : _service = service;

  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  Usuario? _usuarioSelecionado;
  Usuario? get usuarioSelecionado => _usuarioSelecionado;

  EstadoUsuario _estado = EstadoUsuario.inicial;
  EstadoUsuario get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarUsuarios() async {
    // Evita carregamento duplo
    if (_estado == EstadoUsuario.carregando) return;

    _estado = EstadoUsuario.carregando;
    notifyListeners();

    try {
      _usuarios = await _service.buscarUsuarios();
      _estado = EstadoUsuario.carregado;
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao carregar usuários: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> adicionarUsuario(Usuario usuario) async {
    bool isNovo = usuario.id == null;
    _estado = isNovo ? EstadoUsuario.incluindo : EstadoUsuario.alterando;

    notifyListeners();
    try {
      await _service.salvarOuAtualizarUsuario(usuario);
      _estado = isNovo ? EstadoUsuario.incluido : EstadoUsuario.alterado;
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao adicionar usuário: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> removerUsuario(int id) async {
    _estado = EstadoUsuario.deletando;
    notifyListeners();
    try {
      await _service.deletarUsuario(id);
      _estado = EstadoUsuario.deletado;
      notifyListeners();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao remover usuário: $e";
      if (Platform.isAndroid || Platform.isIOS) {
        // Registra o erro no Firebase Crashlytics
        LoggerService.logError(
          e,
          StackTrace.current,
          reason: "Tantou remover usuário",
          information: [
            "ID do usuário: $id",
            "Mensagem de erro: $_mensagemErro",
          ],
          fatal: false,
          // identifier: 'EMPRESA | $id',
        );
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> buscarUsuarioId(int id) async {
    try {
      _usuarioSelecionado = (await _service.buscarUsuarioPorId(id)).firstOrNull;
      notifyListeners();
    } catch (e) {
      _estado = EstadoUsuario.erro;
      _mensagemErro = "Erro ao consultar tipo: $e";
    } finally {
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoUsuario.inicial;
    notifyListeners();
    carregarUsuarios();
  }
}
