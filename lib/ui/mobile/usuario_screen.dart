import 'package:db_sqlite/ui/widgets/menssagens.dart';
import 'package:db_sqlite/ui/widgets/usuario_form.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/viewmodel/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
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
      mostrarSnackBar(
        context: context,
        mensagem: store.mensagemErro!,
        cor: Colors.red,
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoUsuario.deletado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Deletado',
        cor: Colors.orange,
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoUsuario.incluido) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Cadastrado',
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoUsuario.alterado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Alterado',
        cor: Colors.blue,
        limparerro: store.limparErro,
      );
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoUsuario.carregando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Carregando...'),
        );
        break;
      case EstadoUsuario.deletando:
        corpo = Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Deletando...'),
            ],
          ),
        );
        break;
      case EstadoUsuario.incluindo:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'),
        );
        break;
      case EstadoUsuario.alterando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Alterando...'),
        );
        break;
      case EstadoUsuario.carregado:
        corpo = CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: store.usuarios.length,
                (context, index) {
                  final usuario = store.usuarios[index];
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
                        side: BorderSide(
                          color: Colors.blueGrey,
                          width: 0.5,
                        ),
                      ),
                      isThreeLine: false,
                      dense: true,
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(usuario.nome),
                      subtitle: Text(usuario.email),
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
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioUsuario(usuario: usuario)));
                                context.pushRtL(
                                  FormularioUsuario(usuario: usuario),
                                );
                              },
                            ),
                            VerticalDivider(),
                            IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 16,
                              ),
                              onPressed:
                                  () => _confirmarExclusaoUsuario(
                                    context,
                                    usuario.id!,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

        // ListView.builder(
        //   padding: EdgeInsets.all(8),
        //   shrinkWrap: true,
        //   itemCount: store.usuarios.length,
        //   itemBuilder: (_, index) {
        //     final usuario = store.usuarios[index];
        //     return Padding(
        //       padding: const EdgeInsets.only(
        //         left: 16,
        //         right: 16,
        //         top: 4,
        //         bottom: 4,
        //       ),
        //       child: ListTile(
        //         contentPadding: const EdgeInsets.only(
        //           left: 10,
        //           right: 10,
        //           top: 2,
        //           bottom: 1,
        //         ),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           side: BorderSide(
        //             color: Colors.blueGrey,
        //             width: 0.5,
        //           ),
        //         ),
        //         isThreeLine: false,
        //         dense: true,
        //         leading: CircleAvatar(
        //           backgroundColor: Colors.black,
        //           foregroundColor: Colors.white,
        //           child:
        //               usuario.id != null
        //                   ? Text(usuario.id.toString())
        //                   : Icon(Icons.person),
        //         ),
        //         title: Text(usuario.nome),
        //         trailing: Container(
        //           height: MediaQuery.of(context).size.height * 0.04,
        //           decoration: BoxDecoration(
        //             color: Colors.black,
        //             borderRadius: BorderRadius.circular(6),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.black26,
        //                 blurRadius: 4,
        //                 offset: Offset(0, 2),
        //               ),
        //             ],
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               IconButton(
        //                 icon: const Icon(
        //                   Icons.edit_square,
        //                   color: Colors.blue,
        //                   size: 16,
        //                 ),
        //                 onPressed: () {
        //                   // Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioUsuario(usuario: usuario)));
        //                   context.pushRtL(FormularioUsuario(usuario: usuario));
        //                 },
        //               ),
        //               VerticalDivider(),
        //               IconButton(
        //                 icon: Icon(
        //                   Icons.delete_forever,
        //                   color: Colors.red,
        //                   size: 16,
        //                 ),
        //                 onPressed:
        //                     () =>
        //                         _confirmarExclusaoUsuario(context, usuario.id!),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );
        break;
      default:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Padrão...'),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.black,
              applyTextScaling: true,
              size: 35,
            ),
            onPressed: () => context.pushRtL(FormularioUsuario()),
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoUsuario(BuildContext context, int id) {
    final store = Provider.of<UsuarioViewModel>(context, listen: false);
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
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  store.removerUsuario(id);
                  Navigator.of(context).pop();
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
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
