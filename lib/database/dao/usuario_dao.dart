import 'package:db_sqlite/model/usuario.dart';

abstract interface class UsuarioDao {
  Future<void> salvar(Usuario usuario);
  Future<List<Usuario>> listarTodos();
  Future<void> atualizar(Usuario usuario);
  Future<void> deletar(int id);
  Future<List<Usuario>> buscarPorId(int id);
  Future<Usuario?> buscarPorNomeSenha(String nome, String senha);
  Future<bool> verificarUso(int id);
  Future<bool> verificarPadrao(int? id);
}
