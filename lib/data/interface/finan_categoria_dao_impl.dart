import 'package:db_sqlite/data/banco_de_dados.dart';
import 'package:db_sqlite/data/interface/finan_categoria_dao.dart';
import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:sqflite/sqflite.dart';

class FinanCategoriaDaoImpl implements FinanCategoriaDao {
  static const _tableName = 'finan_categoria';

  @override
  Future<void> salvar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, finanCategoria.toMap());
  }

  @override
  Future<List<FinanCategoria>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName);
    return resultado.map((e) => FinanCategoria.fromMap(e)).toList();
  }

  @override
  Future<void> atualizar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    await db.update(
      _tableName,
      finanCategoria.toMap(),
      where: 'id = ?',
      whereArgs: [finanCategoria.id],
    );
  }

  @override
  Future<void> deletar(int id) async {
    final db = await BancoDeDados.banco;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FinanCategoria>> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return resultado.map((e) => FinanCategoria.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'finan_lancamento',
      columns: ['COUNT(*)'],
      where: 'categoriaId = ?',
      whereArgs: [id],
    );

    // debugPrint('Resultado  USO: $resultado');

    if (resultado.isNotEmpty) {
      final count = Sqflite.firstIntValue(resultado);
      return count != null && count > 0;
    }
    return false;
  }

  @override
  Future<bool> verificarPadrao(int? id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(
      _tableName,
      where: 'id IN (?, ?) OR descricao IN (?, ?)',
      whereArgs: [1, 2, 'A Pagar', 'A Receber'],
    );

    bool padrao = resultado.any((row) => row['id'] == id);

    return padrao;
  }
}
