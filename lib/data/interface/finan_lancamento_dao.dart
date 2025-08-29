import 'package:db_sqlite/data/model/finan_lancamento.dart';

abstract interface class FinanLancamentoDao {
  Future<void> salvar(FinanLancamento lancamento);
  Future<int> atualizar(FinanLancamento lancamento);
  Future<int> deletar(int id);
  Future<List<FinanLancamento>> listarTodos();
  Future<List<FinanLancamento>> listarMes();
  Future<FinanLancamento?> buscarPorId(int id);
  Future<List<Map>> totalPorCategoria();
  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId);
}
