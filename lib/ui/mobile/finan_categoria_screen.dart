import 'package:db_sqlite/ui/widgets/finan_categoria_form.dart';
import 'package:db_sqlite/ui/widgets/menssagens.dart';
import 'package:db_sqlite/utils/cores_aleatorias.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/viewmodel/finan_categoria_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanCategoriaScreen extends StatefulWidget {
  const FinanCategoriaScreen({super.key});

  @override
  State<FinanCategoriaScreen> createState() => _FinanCategoriaScreenState();
}

class _FinanCategoriaScreenState extends State<FinanCategoriaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanCategoriaViewModel>(
        context,
        listen: false,
      ).carregarCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanCategoriaViewModel>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoFinanCategoria.erro &&
        store.mensagemErro != null) {
      mostrarSnackBar(
        context: context,
        mensagem: store.mensagemErro!,
        cor: Colors.red,
        limparerro: () => store.limparErro(),
      );
    }

    if (store.estado == EstadoFinanCategoria.deletado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Deletado',
        cor: Colors.orange,
        limparerro: () => store.limparErro(),
      );
    }

    if (store.estado == EstadoFinanCategoria.incluido) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Cadastrado',
        limparerro: () => store.limparErro(),
      );
    }

    if (store.estado == EstadoFinanCategoria.alterado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Alterado',
        cor: Colors.blue,
        limparerro: () => store.limparErro(),
      );
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoFinanCategoria.carregando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Carregando...'),
        );
        break;
      case EstadoFinanCategoria.deletando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Deletando...'),
        );
        break;
      case EstadoFinanCategoria.incluindo:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'),
        );
        break;
      case EstadoFinanCategoria.alterando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Alterando...'),
        );
        break;
      case EstadoFinanCategoria.carregado:
        corpo = RefreshIndicator(
          onRefresh: store.carregarCategorias,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemCount: store.finanCategorias.length,
            itemBuilder: (_, index) {
              final cat = store.finanCategorias[index];
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 4,
                  bottom: 4,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 2,
                    bottom: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blueGrey, width: 0.5),
                  ),
                  isThreeLine: false,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: corAleatoria(cat.id!.toString()),
                    foregroundColor: Colors.white,
                    child:
                        cat.id != null
                            ? Text(cat.id.toString())
                            : Icon(Icons.playlist_add_check_circle_sharp),
                  ),
                  title: Text(cat.descricao ?? ''),
                  trailing: Container(
                    height: MediaQuery.sizeOf(context).height * 0.04,
                    decoration: BoxDecoration(
                      // color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 4,
                      //     offset: Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_square,
                            color: Colors.blue,
                            size: 16,
                          ),
                          onPressed:
                              () => context.pushRtL(
                                FormularioFinanCategoria(categoria: cat),
                              ),
                        ),
                        VerticalDivider(),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 16,
                          ),
                          onPressed:
                              () =>
                                  _confirmarExclusaoCategoria(context, cat.id!),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        break;
      default:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Padrão...'),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria de Finanças'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.grey.shade300,
              applyTextScaling: true,
              size: 35,
            ),
            onPressed: () => context.pushRtL(FormularioFinanCategoria()),
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoCategoria(BuildContext context, int id) {
    final store = Provider.of<FinanCategoriaViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir Categoria'),
            content: Text('Deseja realmente excluir a Categoria?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor: WidgetStatePropertyAll(Colors.blue),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await store.removerCategoria(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
