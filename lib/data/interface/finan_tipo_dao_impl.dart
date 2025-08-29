import 'package:db_sqlite/data/banco_de_dados.dart';
import 'package:db_sqlite/data/interface/finan_tipo_dao.dart';
import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:sqflite/sqflite.dart';

class FinanTipoDaoImpl implements FinanTipoDao {
  static const _tableName = 'finan_tipo';

  @override
  Future<void> salvar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, finanTipo.toMap());
  }

  @override
  Future<List<FinanTipo>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName);
    return resultado.map((e) => FinanTipo.fromMap(e)).toList();
  }

  @override
  Future<void> atualizar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    await db.update(
      _tableName,
      finanTipo.toMap(),
      where: 'id = ?',
      whereArgs: [finanTipo.id],
    );
  }

  @override
  Future<void> deletar(int id) async {
    final db = await BancoDeDados.banco;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FinanTipo>> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return resultado.map((e) => FinanTipo.fromMap(e)).toList();
    }
    return [];
  }

  @override
  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(
      'finan_lancamento',
      columns: ['COUNT(*)'],
      where: 'tipoId = ?',
      whereArgs: [id],
    );

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
      whereArgs: [1, 'Geral'],
    );

    bool padrao = resultado.any((row) => row['id'] == id);

    return padrao;
  }

  @override
  Future<List<FinanTipo>> findBy({int limit = 14, int offset = 0}) async {
    final db = await BancoDeDados.banco;
    final res = await db.query(
      _tableName,
      limit: limit,
      offset: offset,
      orderBy: 'id ASC', // É uma boa prática ter uma ordem definida
    );
    return res.map((json) => FinanTipo.fromMap(json)).toList();
  }
}
