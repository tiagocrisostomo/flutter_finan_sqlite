import 'package:db_sqlite/data/banco_de_dados.dart';
import 'package:db_sqlite/data/interface/finan_lancamento_dao.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class FinanLancamentoDaoImpl implements FinanLancamentoDao {
  static const _tableName = 'finan_lancamento';

  @override
  Future<void> salvar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, lancamento.toMap());
  }

  @override
  Future<int> atualizar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    return await db.update(
      _tableName,
      lancamento.toMap(),
      where: 'id = ?',
      whereArgs: [lancamento.id],
    );
  }

  @override
  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FinanLancamento>> listarTodos() async {
    String sql = '''SELECT
      fl.id,
      fl.descricao,
      fl.valor,
      fl.data,
      fl.categoriaId,
      fl.tipoId,
      fl.usuarioId,
      fc.descricao AS categoriaDescricao,
      ft.descricao AS tipoDescricao,
      u.nome AS usuarioNome
     FROM finan_lancamento fl
     INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
     INNER JOIN finan_tipo ft ON fl.tipoId = ft.id
     INNER JOIN usuario u ON fl.usuarioId = u.id
     ORDER BY fl.data DESC
  ''';
    final db = await BancoDeDados.banco;
    final lancamentos = await db.rawQuery(sql);
    return lancamentos
        .map((lancamento) => FinanLancamento.fromMap(lancamento))
        .toList();
  }

  @override
  Future<List<FinanLancamento>> listarMes() async {
    String sql = '''SELECT
      fl.id,
      fl.descricao,
      fl.valor,
      fl.data,
      fl.categoriaId,
      fl.tipoId,
      fl.usuarioId,
      fc.descricao AS categoriaDescricao,
      ft.descricao AS tipoDescricao,
      u.nome AS usuarioNome
     FROM finan_lancamento fl
     INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
     INNER JOIN finan_tipo ft ON fl.tipoId = ft.id
     INNER JOIN usuario u ON fl.usuarioId = u.id
     WHERE strftime('%Y-%m', fl.data) = strftime('%Y-%m', 'now')
     ORDER BY fl.data DESC
  ''';

    final db = await BancoDeDados.banco;
    final lancamentos = await db.rawQuery(sql);
    return lancamentos
        .map((lancamento) => FinanLancamento.fromMap(lancamento))
        .toList();
  }

  @override
  Future<FinanLancamento?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return FinanLancamento.fromMap(resultado.first);
    }
    return null;
  }

  @override
  Future<List<Map>> totalPorCategoria() async {
    final db = await BancoDeDados.banco;
    final result = await db.rawQuery(
      '''SELECT fc.descricao as categoria, SUM(fl.valor) as total
         FROM finan_lancamento fl
         INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
         GROUP BY fc.descricao
         ORDER BY fc.descricao''',
    );

    if (result.isEmpty) return [];

    return result;
  }

  @override
  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId) async {
    final db = await BancoDeDados.banco;
    final maps = await db.query(
      'finan_lancamento',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }
}
