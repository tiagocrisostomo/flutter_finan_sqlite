import 'package:db_sqlite/ui/mobile/finan_lancamento_screen_todos.dart';
import 'package:db_sqlite/ui/widgets/finan_lancamento_form.dart';
import 'package:db_sqlite/ui/widgets/menssagens.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/viewmodel/finan_lancamento_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanLancamentoScreen extends StatefulWidget {
  const FinanLancamentoScreen({super.key});

  @override
  State<FinanLancamentoScreen> createState() => _FinanLancamentoScreenState();
}

class _FinanLancamentoScreenState extends State<FinanLancamentoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoViewModel>(
        context,
        listen: false,
      ).carregarLancamentosMes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanLancamentoViewModel>(context);

    // Mostra erro caso ocorra
    if (store.estado == EstadoLancamento.erro && store.mensagemErro != null) {
      mostrarSnackBar(
        context: context,
        mensagem: store.mensagemErro!,
        cor: Colors.red,
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoLancamento.deletado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Deletado',
        cor: Colors.orange,
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoLancamento.incluido) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Cadastrado',
        limparerro: store.limparErro,
      );
    }

    if (store.estado == EstadoLancamento.alterado) {
      mostrarSnackBar(
        context: context,
        mensagem: 'Alterado',
        cor: Colors.blue,
        limparerro: store.limparErro,
      );
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoLancamento.carregando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Carregando...'),
        );
        break;
      case EstadoLancamento.deletando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Deletando...'),
        );
        break;
      case EstadoLancamento.incluindo:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'),
        );
        break;
      case EstadoLancamento.alterando:
        corpo = Center(
          child: CircularProgressIndicator(semanticsLabel: 'Alterando...'),
        );
        break;
      case EstadoLancamento.carregado:
        corpo = RefreshIndicator(
          onRefresh: store.carregarLancamentosMes,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text('Lançamentos Financeiros'),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () => context.pushRtL(FinanLancamentoForm()),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: store.lancamentosMes.length,
                  (context, index) {
                    final lanc = store.lancamentosMes[index];
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
                          // maxRadius: MediaQuery.sizeOf(context).width * 0.07,
                          backgroundColor:
                              lanc.categoriaId == 1
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                          child: Text(
                            lanc.tipoDescricao.toString(),
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        title: Text(
                          'R\$ ${lanc.valor.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${lanc.categoriaDescricao.toString()} - ${DateFormat('dd/MM/yyyy').format(lanc.data as DateTime)} \n'
                          '${lanc.descricao.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
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
                                      FinanLancamentoForm(lancamento: lanc),
                                    ),
                              ),
                              VerticalDivider(),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                onPressed:
                                    () => _confirmarExclusao(context, lanc.id!),
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
          ),
        );

        // ListView.builder(
        //   shrinkWrap: true,
        //   padding: EdgeInsets.all(8),
        //   itemCount: store.lancamentosMes.length,
        //   itemBuilder: (_, index) {
        //     final lanc = store.lancamentosMes[index];
        //     return Padding(
        //       padding: const EdgeInsets.all(2.0),
        //       child: ListTile(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           side: BorderSide(color: Colors.blueGrey, width: 0.5),
        //         ),
        //         isThreeLine: false,
        //         dense: true,
        //         leading: CircleAvatar(
        //           // maxRadius: MediaQuery.sizeOf(context).width * 0.07,
        //           backgroundColor:
        //               lanc.categoriaId == 1
        //                   ? Colors.red.shade700
        //                   : Colors.green.shade700,
        //           child: Text(
        //             lanc.tipoDescricao.toString(),
        //             softWrap: true,
        //             style: TextStyle(
        //               fontSize: 12,
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //           ),
        //         ),
        //         title: Text(
        //           'R\$ ${lanc.valor.toStringAsFixed(2)}',
        //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        //         ),
        //         subtitle: Text(
        //           '${lanc.categoriaDescricao.toString()} - ${DateFormat('dd/MM/yyyy').format(lanc.data as DateTime)} \n'
        //           '${lanc.descricao.toString()}',
        //           style: TextStyle(fontSize: 12, color: Colors.black54),
        //         ),
        //         trailing: Container(
        //           height: MediaQuery.sizeOf(context).height * 0.04,
        //           decoration: BoxDecoration(
        //             // color: Colors.black,
        //             borderRadius: BorderRadius.circular(6),
        //             // boxShadow: [
        //             //   BoxShadow(
        //             //     color: Colors.black26,
        //             //     blurRadius: 4,
        //             //     offset: Offset(0, 2),
        //             //   ),
        //             // ],
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
        //                 onPressed:
        //                     () => context.pushRtL(
        //                       FinanLancamentoForm(lancamento: lanc),
        //                     ),
        //               ),
        //               VerticalDivider(),
        //               IconButton(
        //                 icon: const Icon(
        //                   Icons.delete_forever,
        //                   color: Colors.red,
        //                   size: 16,
        //                 ),
        //                 onPressed: () => _confirmarExclusao(context, lanc.id!),
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
      // appBar: AppBar(
      //   title: const Text(
      //     'Lançamentos Financeiros do mês',
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.add_box_rounded,
      //         color: Colors.black,
      //         applyTextScaling: true,
      //         size: 35,
      //       ),
      //       onPressed: () => context.pushRtL(FinanLancamentoForm()),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: corpo,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        // padding: const EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.sizeOf(context).height * 0.05,
        width: MediaQuery.sizeOf(context).width * 1,
        child: FloatingActionButton.extended(
          icon: Icon(
            Icons.arrow_circle_right,
            size: 30,
            color: Colors.black,
          ),
          label: Text(
            'Ver todos os lançamentos       ',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () => context.pushRtL(FinanLancamentoScreenTodos()),
          isExtended: true,
          backgroundColor: Colors.green.shade600,
          tooltip: 'Ver todos os lançamentos',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, int id) {
    final store = Provider.of<FinanLancamentoViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir este lançamento?'),
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
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  await store.removerLancamento(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
