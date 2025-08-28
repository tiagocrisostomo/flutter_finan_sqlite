import 'package:db_sqlite/database/dao/finan_categoria_dao.dart';
import 'package:db_sqlite/model/finan_categoria.dart';

class FinanCategoriaService {
  final FinanCategoriaDAO _dao = FinanCategoriaDAO();

  Future<void> salvarOuAtualizarCategoria(FinanCategoria finanCategoria) async {
    if (finanCategoria.id == null) {
      await _dao.salvar(finanCategoria);
    } else {
      await _dao.atualizar(finanCategoria);
    }
  }

  Future<List<FinanCategoria>> buscarCategoriaPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<List<FinanCategoria>> buscarCategorias() async {
    return await _dao.listarTodos();
  }

  Future<void> deletarCategoria(int id) async {
    // Verifica se a categoria está em usome/ou é padrão
    final emUso = await _dao.verificarUso(id);
    final catPadrao = await _dao.verificarPadrao(id);

    if (catPadrao) {
      throw Exception('Categoria padrão não pode ser deletada.');
    }
    if (emUso) {
      throw Exception('Categoria em uso e não pode ser deletada.');
    }
    await _dao.deletar(id);
  }
}
