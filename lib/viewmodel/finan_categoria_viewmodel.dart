import 'package:db_sqlite/model/finan_categoria.dart';
import 'package:db_sqlite/service/finan_categoria_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanCategoria { inicial, carregando, carregado, erro, deletando, deletado, incluindo, incluido, alterando, alterado }

class FinanCategoriaViewModel extends ChangeNotifier {
  final FinanCategoriaService _service = FinanCategoriaService();

  List<FinanCategoria> _finanCategorias = [];
  List<FinanCategoria> get finanCategorias => _finanCategorias;

  FinanCategoria? _categoriaSelecionada;
  FinanCategoria? get categoriaSelecionada => _categoriaSelecionada;

  EstadoFinanCategoria _estado = EstadoFinanCategoria.inicial;
  EstadoFinanCategoria get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarCategorias() async {
    // Evita carregamento duplo
    if (_estado == EstadoFinanCategoria.carregando) return;

    _estado = EstadoFinanCategoria.carregando;
    notifyListeners();

    try {
      _finanCategorias = await _service.buscarCategorias();
      _estado = EstadoFinanCategoria.carregado;
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao carregar categorias: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> adicionarCategoria(FinanCategoria finanCategoria) async {
    bool isNovo = finanCategoria.id == null;
    _estado = isNovo ? EstadoFinanCategoria.incluindo : EstadoFinanCategoria.alterando;
    notifyListeners();
    try {
      await _service.salvarOuAtualizarCategoria(finanCategoria);
      _estado = isNovo ? EstadoFinanCategoria.incluido : EstadoFinanCategoria.alterado;
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao adicionar categoria: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> removerCategoria(int id) async {
    _estado = EstadoFinanCategoria.deletando;
    notifyListeners();
    try {
      await _service.deletarCategoria(id);
      _estado = EstadoFinanCategoria.deletado;
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao remover categoria: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> buscarCategoriaId(int id) async {
    try {
      _categoriaSelecionada = (await _service.buscarCategoriaPorId(id)).firstOrNull;
      notifyListeners();
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao consultar categoria: $e";
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoFinanCategoria.inicial;
    notifyListeners();
    carregarCategorias();
  }
}
