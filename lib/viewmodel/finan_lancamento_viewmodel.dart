import 'package:db_sqlite/model/finan_categoria.dart';
import 'package:db_sqlite/model/finan_lancamento.dart';
import 'package:db_sqlite/model/finan_tipo.dart';
import 'package:db_sqlite/model/usuario.dart';
import 'package:db_sqlite/service/finan_categoria_service.dart';
import 'package:db_sqlite/service/finan_lancamento_service.dart';
import 'package:db_sqlite/service/finan_tipo_service.dart';
import 'package:db_sqlite/service/usuario_service.dart';
import 'package:flutter/material.dart';

enum EstadoLancamento {
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

class FinanLancamentoViewModel extends ChangeNotifier {
  final FinanLancamentoService _service = FinanLancamentoService();
  final FinanTipoService _tipoService = FinanTipoService();
  final FinanCategoriaService _categoriaService = FinanCategoriaService();
  final UsuarioService _usuarioService = UsuarioService();

  List<FinanTipo> _tipos = [];
  List<FinanCategoria> _categorias = [];
  List<Usuario> _usuarios = [];

  List<FinanLancamento> _lancamentos = [];
  List<FinanLancamento> get lancamentos => _lancamentos;

  List<FinanLancamento> _lancamentosMes = [];
  List<FinanLancamento> get lancamentosMes => _lancamentosMes;

  EstadoLancamento _estado = EstadoLancamento.inicial;
  EstadoLancamento get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  double get totalApagar => _lancamentosMes
      .where((l) => l.categoriaId == 1)
      .fold(0.0, (total, l) => total + l.valor);

  double get totalAreceber => _lancamentosMes
      .where((l) => l.categoriaId == 2)
      .fold(0.0, (total, l) => total + l.valor);

  double get saldoTotal => totalAreceber - totalApagar;

  Future<void> carregarLancamentos() async {
    // Evita carregamento duplo
    if (_estado == EstadoLancamento.carregando) return;

    _estado = EstadoLancamento.carregando;
    notifyListeners();

    try {
      _lancamentos = await _service.buscarLancamentos();
      _estado = EstadoLancamento.carregado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao carregar lançamentos: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarLancamentosMes() async {
    // Evita carregamento duplo
    if (_estado == EstadoLancamento.carregando) return;

    _estado = EstadoLancamento.carregando;
    notifyListeners();

    try {
      _lancamentosMes = await _service.buscarLancamentoMes();
      _estado = EstadoLancamento.carregado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao carregar lançamentos do mês: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> adicionarOuEditarLancamento(FinanLancamento lancamento) async {
    bool isNovo = lancamento.id == null;
    _estado = isNovo ? EstadoLancamento.incluindo : EstadoLancamento.alterando;

    notifyListeners();

    try {
      await _service.salvarOuAtualizarLancamento(lancamento);
      _estado = isNovo ? EstadoLancamento.incluido : EstadoLancamento.alterado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao salvar lançamento: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> removerLancamento(int id) async {
    _estado = EstadoLancamento.deletando;
    notifyListeners();
    try {
      await _service.deletarLancamento(id);
      _estado = EstadoLancamento.deletado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao remover lançamento: $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarTipos() async {
    _tipos = await _tipoService.buscarTipos();
  }

  Future<void> carregarCategorias() async {
    _categorias = await _categoriaService.buscarCategorias();
  }

  Future<void> carregarUsuarios() async {
    _usuarios = await _usuarioService.buscarUsuarios();
  }

  Map<String, double> totaisPorTipoDescricao() {
    carregarTipos();
    final Map<String, double> totais = {};
    for (var t in _lancamentosMes) {
      final tipo = _tipos.firstWhere(
        (tipo) => tipo.id == t.tipoId,
        orElse: () => FinanTipo(id: t.tipoId, descricao: 'Tipo ${t.tipoId}'),
      );
      totais[tipo.descricao.toString()] =
          (totais[tipo.descricao] ?? 0) + t.valor;
    }
    // debugPrint(totais.toString());
    return totais;
  }

  Map<String, double> totaisPorCategoriaDescricao() {
    carregarCategorias();
    final Map<String, double> totais = {};
    for (var t in _lancamentosMes) {
      final categoria = _categorias.firstWhere(
        (c) => c.id == t.categoriaId,
        orElse:
            () => FinanCategoria(
              id: t.categoriaId,
              descricao: 'Categoria ${t.categoriaId}',
            ),
      );
      totais[categoria.descricao.toString()] =
          (totais[categoria.descricao] ?? 0) + t.valor;
    }
    // debugPrint(totais.toString());
    return totais;
  }

  Map<String, dynamic> totaisPorUsuarioNome() {
    carregarUsuarios();
    final Map<String, dynamic> totais = {};
    for (var t in _lancamentosMes) {
      final usuario = _usuarios.firstWhere(
        (u) => u.id == t.usuarioId,
        orElse:
            () => Usuario(
              id: t.usuarioId,
              nome: 'Usuário ${t.usuarioId}',
              senha: 'senha',
              email: 'email',
            ),
      );
      totais[usuario.nome.toString()] = (totais[usuario.nome] ?? 0) + t.valor;
    }
    // debugPrint(totais.toString());
    return totais;
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoLancamento.inicial;
    notifyListeners();
    carregarLancamentosMes();
  }
}
