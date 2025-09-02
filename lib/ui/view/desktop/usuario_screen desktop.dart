// ignore_for_file: file_names

import 'package:db_sqlite/util/routes_context_transations.dart';
import 'package:db_sqlite/ui/widget/usuario_form.dart';
import 'package:db_sqlite/ui/viewmodel/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioScreenDesktop extends StatefulWidget {
  const UsuarioScreenDesktop({super.key});

  @override
  State<UsuarioScreenDesktop> createState() => _UsuarioScreenDesktopState();
}

class _UsuarioScreenDesktopState extends State<UsuarioScreenDesktop> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioViewModel>(context, listen: false).carregarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UsuarioViewModel>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoUsuario.erro && store.mensagemErro != null) {
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

    if (store.estado == EstadoUsuario.deletado) {
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

    if (store.estado == EstadoUsuario.incluido) {
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

    if (store.estado == EstadoUsuario.alterado) {
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
      case EstadoUsuario.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoUsuario.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoUsuario.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoUsuario.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoUsuario.carregado:
        corpo = RefreshIndicator(
          onRefresh: () async {
            await store.carregarUsuarios();
          }, // Permite "puxar para recarregar"
          child: ListView.builder(
            // controller: _scrollController,
            padding: EdgeInsets.all(8),
            itemCount: store.usuarios.length,
            itemBuilder: (_, index) {
              final usuario = store.usuarios[index];
              return Container(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.blueGrey, width: 0.5)),
                  isThreeLine: false,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    child: usuario.id != null ? Text(usuario.id.toString()) : Icon(Icons.person),
                  ),
                  title: Text(usuario.nome),
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
                          onPressed: () => context.pushBtTModal(FormularioUsuario(usuario: usuario)),
                        ),
                        VerticalDivider(),
                        IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red, size: 16),
                          onPressed: () => _confirmarExclusaoUsuario(context, usuario.id!),
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
        title: Text('Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Colors.black, applyTextScaling: true, size: 35),
            onPressed: () => context.pushRtL(FormularioUsuario()),
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoUsuario(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir usuário'),
            content: Text('Deseja realmente excluir o usuário?'),
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
                onPressed: () {
                  Provider.of<UsuarioViewModel>(context, listen: false).removerUsuario(id);
                  Navigator.of(context).pop();
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
