import 'package:db_sqlite/data/interface/usuario_dao_impl.dart';
import 'package:db_sqlite/data/model/usuario.dart';

class AuthService {
  final UsuarioDaoImpl _usuarioDao;

  AuthService({required UsuarioDaoImpl usuarioDao}) : _usuarioDao = usuarioDao;

  Future<Usuario?> login(String nome, String senha) async {
    final usuario = await _usuarioDao.buscarPorNomeSenha(nome, senha);
    if (usuario != null) {
      return usuario;
    }
    return null;
  }
}
