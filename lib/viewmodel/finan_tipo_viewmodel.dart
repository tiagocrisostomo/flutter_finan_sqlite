import 'package:db_sqlite/model/finan_tipo.dart';
import 'package:db_sqlite/service/finan_tipo_service.dart';
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
  final FinanTipoService _service = FinanTipoService();

  List<FinanTipo> _finanTipos = [];
  List<FinanTipo> get finanTipos => _finanTipos;

  List<FinanTipo> _finanTodosTipos = [];
  List<FinanTipo> get finanTodosTipos => _finanTodosTipos;

  List<FinanTipo> _finanTipo = [];
  List<FinanTipo> get finanTipo => _finanTipo;

  EstadoFinanTipo _estado = EstadoFinanTipo.inicial;
  EstadoFinanTipo get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  // Variáveis para o Lazy Loading
  final int _pageSize = 14;
  int _offset = 0;
  bool _hasMoreItems = true;
  bool get hasMoreItems => _hasMoreItems;

  Future<void> carregarTipos() async {
    // Evita carregamento duplo
    if (_estado == EstadoFinanTipo.carregando) return;

    _estado = EstadoFinanTipo.carregando;
    notifyListeners();

    _offset = 0; // Reseta o offset para carregar do início
    _hasMoreItems = true;

    try {
      final newTipos = await _service.getTipos(
        limit: _pageSize,
        offset: _offset,
      );

      _finanTipos = newTipos;
      if (newTipos.length < _pageSize) {
        _hasMoreItems = false;
      } else {
        _offset += _pageSize;
      }

      _estado = EstadoFinanTipo.carregado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar tipos: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarMaisTipos() async {
    // Evita carregamento duplo ou se não houver mais itens
    if (!_hasMoreItems || _estado == EstadoFinanTipo.carregandoMais) {
      return;
    }

    _estado = EstadoFinanTipo.carregandoMais;
    notifyListeners();

    try {
      final newTipos = await _service.getTipos(
        limit: _pageSize,
        offset: _offset,
      );

      if (newTipos.isEmpty) {
        _hasMoreItems = false;
      } else {
        _finanTipos.addAll(newTipos);
        _offset += newTipos.length;
      }

      _estado = EstadoFinanTipo.carregadoMais;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar mais tipos: $e";
    } finally {
      notifyListeners();
    }
  }

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
      notifyListeners();
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
    carregarTipos();
  }
}
