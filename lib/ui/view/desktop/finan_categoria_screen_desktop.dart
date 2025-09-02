import 'package:db_sqlite/ui/viewmodel/finan_categoria_viewmodel.dart';
import 'package:db_sqlite/util/routes_context_transations.dart';
import 'package:db_sqlite/ui/widget/finan_categoria_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanCategoriaScreenDesktop extends StatefulWidget {
  const FinanCategoriaScreenDesktop({super.key});

  @override
  State<FinanCategoriaScreenDesktop> createState() => _FinanCategoriaScreenDesktopState();
}

class _FinanCategoriaScreenDesktopState extends State<FinanCategoriaScreenDesktop> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanCategoriaViewModel>(context, listen: false).carregarCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanCategoriaViewModel>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoFinanCategoria.erro && store.mensagemErro != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.mensagemErro!),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanCategoria.deletado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deletado'),

            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanCategoria.incluido) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastrado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanCategoria.alterado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alterado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoFinanCategoria.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoFinanCategoria.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoFinanCategoria.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoFinanCategoria.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoFinanCategoria.carregado:
        corpo = RefreshIndicator(
          onRefresh: () async {
            await store.carregarCategorias();
          },
          child: ListView.builder(
            // controller: _scrollController,
            padding: EdgeInsets.all(8),
            itemCount: store.finanCategorias.length,
            itemBuilder: (_, index) {
              final cat = store.finanCategorias[index];
              return Container(
                padding: const EdgeInsets.all(2),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.blueGrey, width: 0.5)),
                  isThreeLine: false,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    child: cat.id != null ? Text(cat.id.toString()) : Icon(Icons.playlist_add_check_circle_sharp),
                  ),
                  title: Text(cat.descricao ?? ''),
                  trailing: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_square, color: Colors.blue, size: 16),
                          onPressed: () => context.pushBtTModal(FormularioFinanCategoria(categoria: cat)),
                        ),
                        VerticalDivider(),
                        IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red, size: 16),
                          onPressed: () => _confirmarExclusaoCategoria(context, cat.id!),
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
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Padrão...'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria de Finanças', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Colors.black, applyTextScaling: true, size: 35),
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
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
