import 'package:db_sqlite/ui/viewmodel/finan_tipo_viewmodel.dart';
import 'package:db_sqlite/util/routes_context_transations.dart';
import 'package:db_sqlite/ui/widget/finan_tipo_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanTipoScreenDesktop extends StatefulWidget {
  const FinanTipoScreenDesktop({super.key});

  @override
  State<FinanTipoScreenDesktop> createState() => _FinanTipoScreenDesktopState();
}

class _FinanTipoScreenDesktopState extends State<FinanTipoScreenDesktop> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanTipoViewModel>(context, listen: false).carregarTodosTipos();
    });
  }


  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanTipoViewModel>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoFinanTipo.erro && store.mensagemErro != null) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.deletado) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.incluido) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.alterado) {
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
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    // 6. Ajustar a lógica de exibição para lidar com o novo estado
    if (store.estado == EstadoFinanTipo.carregando && store.finanTodosTipos.isEmpty) {
      corpo = const Center(child: CircularProgressIndicator());
    } else if (store.finanTodosTipos.isEmpty) {
      // Condição para quando não há itens
      corpo = const Center(child: Text('Nenhum tipo encontrado.'));
    } else {
      // 7. Modificar o ListView.builder para suportar o lazy loading
      corpo = RefreshIndicator(
        onRefresh: () async {
          await store.carregarTodosTipos();
        }, // Permite "puxar para recarregar"
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: store.finanTodosTipos.length,
          itemBuilder: (_, index) {
            // Se o index for o último, exibe o indicador de carregamento
            if (index == store.finanTodosTipos.length) {
              return const Padding(
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Column(
                    children: [Text("Arrasta para cima e carregue mais Tipos..."), SizedBox(height: 6), LinearProgressIndicator(), SizedBox(height: 80)],
                  ),
                ),
              );
            }
            // Caso contrário, exibe o item normalmente
            final tipo = store.finanTodosTipos[index];
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
                  child: tipo.id != null ? Text(tipo.id.toString()) : const Icon(Icons.playlist_add_check_circle_sharp),
                ),
                title: Text(tipo.descricao ?? ''),
                trailing: Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_square, color: Colors.blue, size: 16),
                        onPressed: () => context.pushBtTModal(FormularioFinanTipo(tipo: tipo)),
                      ),
                      const VerticalDivider(),
                      IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.red, size: 16),
                        onPressed: () => _confirmarExclusaoTipo(context, tipo.id!),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Finanças'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Colors.black, applyTextScaling: true, size: 35),
            onPressed: () => context.pushRtL(FormularioFinanTipo()),
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoTipo(BuildContext context, int id) {
    final store = Provider.of<FinanTipoViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir Tipo'),
            content: Text('Deseja realmente excluir o Tipo?'),
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
                  await store.removerTipo(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
