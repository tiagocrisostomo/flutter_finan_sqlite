import 'package:db_sqlite/database/banco_de_dados.dart';
import 'package:db_sqlite/model/usuario.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDAO {
  static const String _tablename = 'usuario';

  Future<void> salvar(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    final usuarioComSenhaHash = Usuario(id: usuario.id, nome: usuario.nome, email: usuario.email, senha: Seguranca.hashSenha(usuario.senha));

    await db.insert('usuario', usuarioComSenhaHash.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Usuario>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tablename);
    return resultado.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> atualizar(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    return await db.update(_tablename, usuario.toMap(), where: 'id = ?', whereArgs: [usuario.id]);
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete(_tablename, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Usuario>> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tablename, where: 'id = ?', whereArgs: [id]);
    if (resultado.isNotEmpty) {
      return resultado.map((e) => Usuario.fromMap(e)).toList();
    }
    return [];
  }

  Future<Usuario?> buscarPorNomeSenha(String nome, String senha) async {
    final db = await BancoDeDados.banco;
    final senhaHash = Seguranca.hashSenha(senha);

    final maps = await db.query(_tablename, where: 'nome = ? AND senha = ?', whereArgs: [nome, senhaHash]);
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('finan_lancamento', columns: ['count(*)'], where: 'usuarioId = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final count = Sqflite.firstIntValue(resultado);
      return count != null && count > 0;
    }
    return false;
  }

  Future<bool> verificarPadrao(int? id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(_tablename, where: 'id = ? OR nome = ?', whereArgs: [1, 'admin']);

    bool padrao = resultado.any((row) => row['id'] == id);

    return padrao;
  }
}
