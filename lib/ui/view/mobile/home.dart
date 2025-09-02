import 'package:db_sqlite/ui/view/mobile/configuracao_screen.dart';
import 'package:db_sqlite/ui/view/mobile/finan_lancamento_screen.dart';
import 'package:db_sqlite/ui/widget/finan_painel.dart';
import 'package:db_sqlite/ui/widget/menssagens.dart';
import 'package:db_sqlite/ui/viewmodel/conectividade_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;

  final List<Widget> paginas = [
    const PainelFinanceiro(),
    const FinanLancamentoScreen(),
    const ConfigScreen(), // ou alguma outra tela
  ];

  ConnectivityViewModel? _connectivityService;
  VoidCallback? _connectivityListener;

  @override
  void initState() {
    super.initState();

    // Aguardar até o primeiro frame ser renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectivityService = Provider.of<ConnectivityViewModel>(
        context,
        listen: false,
      );

      _connectivityListener = () {
        final status = _connectivityService!.connectionStatus;
        final isOffline = status.contains("NÃO");

        // _mostrarSnackBar(
        //   isOffline ? 'Sem conexão com a internet' : 'Conexão ok',
        //   cor: isOffline ? Colors.red : Colors.green,
        // );
        mostrarSnackBar(
          context: context,
          mensagem: isOffline ? 'Sem conexão com a internet' : 'Conexão ok',
          limparerro: () {},
          cor: isOffline ? Colors.red : Colors.green,
        );
      };

      _connectivityService!.addListener(_connectivityListener!);
    });
  }

  @override
  void dispose() {
    // Remove listener ao destruir a tela
    _connectivityService?.removeListener(_connectivityListener!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final store = Provider.of<TrocarTemaViewModel>(context);
    return Scaffold(
      // appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.brightness_6), onPressed: () => context.read<TrocarTemaViewModel>().trocarTema()),
        // leading: Switch(value: store.isDarkTheme, onChanged: (bool value) => store.trocarTema()),
        // title: const Text('Controle Financeiro'),
        // centerTitle: true,
      // ),

      body: paginas[paginaAtual],
      // body: Center(child: Text(store.temaAtual.toString())),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) => setState(() => paginaAtual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Painel'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Lançamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuração',
          ),
        ],
      ),
    );
  }
}
