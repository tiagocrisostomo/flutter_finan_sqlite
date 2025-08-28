import 'package:db_sqlite/database/dao/usuario_dao.dart';
import 'package:db_sqlite/model/usuario.dart';

class AuthService {
  final UsuarioDAO _dao = UsuarioDAO();

  Future<Usuario?> login(String nome, String senha) async {
    final usuario = await _dao.buscarPorNomeSenha(nome, senha);
    if (usuario != null) {
      return usuario;
    }
    return null;
  }
}
