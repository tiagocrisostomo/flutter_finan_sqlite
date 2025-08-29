import 'package:db_sqlite/data/model/finan_categoria.dart';

abstract interface class FinanCategoriaDao {
  Future<void> salvar(FinanCategoria categoria);
  Future<void> atualizar(FinanCategoria categoria);
  Future<void> deletar(int id);
  Future<List<FinanCategoria>> listarTodos();
  Future<List<FinanCategoria>> buscarPorId(int id);
  Future<bool> verificarUso(int id);
  Future<bool> verificarPadrao(int? id);
}
