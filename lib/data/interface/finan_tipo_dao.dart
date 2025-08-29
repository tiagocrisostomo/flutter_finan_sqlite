import 'package:db_sqlite/data/model/finan_tipo.dart';

abstract interface class FinanTipoDao {
  Future<void> salvar(FinanTipo finanTipo);
  Future<void> atualizar(FinanTipo finanTipo);
  Future<void> deletar(int id);
  Future<List<FinanTipo>> listarTodos();
  Future<List<FinanTipo>> buscarPorId(int id);
  Future<bool> verificarUso(int id);
  Future<bool> verificarPadrao(int? id);
  Future<List<FinanTipo>> findBy({int limit, int offset});
}
