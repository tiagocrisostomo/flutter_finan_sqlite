import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:db_sqlite/data/service/finan_tipo_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanTipo {
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
  carregandoMais,
  carregadoMais,
}

class FinanTipoViewModel extends ChangeNotifier {
  final FinanTipoService _service;

  FinanTipoViewModel({required FinanTipoService service}) : _service = service;

  List<FinanTipo> _finanTodosTipos = [];
  List<FinanTipo> get finanTodosTipos => _finanTodosTipos;

  List<FinanTipo> _finanTipo = [];
  List<FinanTipo> get finanTipo => _finanTipo;

  EstadoFinanTipo _estado = EstadoFinanTipo.inicial;
  EstadoFinanTipo get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarTodosTipos() async {
    if (_estado == EstadoFinanTipo.carregando) return;
    _estado = EstadoFinanTipo.carregando;
    notifyListeners();
    try {
      _finanTodosTipos = await _service.buscarTipos();
      _estado = EstadoFinanTipo.carregado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar tipos: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> adicionarTipo(FinanTipo finanTipo) async {
    bool isNovo = finanTipo.id == null;
    _estado = isNovo ? EstadoFinanTipo.incluindo : EstadoFinanTipo.alterando;

    notifyListeners();
    try {
      await _service.salvarOuAtualizarTipo(finanTipo);
      _estado = isNovo ? EstadoFinanTipo.incluido : EstadoFinanTipo.alterado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao adicionar tipo: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> removerTipo(int id) async {
    _estado = EstadoFinanTipo.deletando;
    notifyListeners();
    try {
      await _service.deletarTipo(id);
      _estado = EstadoFinanTipo.deletado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao remover tipo: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> buscarTipoId(int id) async {
    try {
      _finanTipo = await _service.buscarTipoPorId(id);
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao consultar tipo: $e";
    } finally {
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoFinanTipo.inicial;
    notifyListeners();
    carregarTodosTipos();
  }
}
