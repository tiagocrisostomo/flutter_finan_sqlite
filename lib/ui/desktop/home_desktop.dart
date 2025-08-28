import 'package:db_sqlite/ui/desktop/configuracao_screen_desktop.dart';
import 'package:db_sqlite/ui/desktop/finan_lancamento_screen_desktop.dart';
import 'package:db_sqlite/ui/widgets/finan_painel.dart';
import 'package:db_sqlite/viewmodel/conectividade_check_viewmodel.dart';
import 'package:db_sqlite/viewmodel/trocar_tema_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  int paginaAtual = 0;

  final List<Widget> paginas = [
    const PainelFinanceiro(),
    const FinanLancamentoScreenDesktop(),
    const ConfigScreenDesktop(), // ou alguma outra tela
  ];

  ConnectivityViewModel? _connectivityService;
  VoidCallback? _connectivityListener;

  @override
  void initState() {
    super.initState();

    // Aguardar até o primeiro frame ser renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectivityService = Provider.of<ConnectivityViewModel>(context, listen: false);

      _connectivityListener = () {
        final status = _connectivityService!.connectionStatus;
        final isOffline = status.contains("NÃO");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isOffline ? 'Sem conexão com a internet' : 'Conexão restaurada'),
            backgroundColor: isOffline ? Colors.red : Colors.green,
            duration: const Duration(seconds: 3),
          ),
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
    final store = Provider.of<TrocarTemaViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Switch(value: store.isDarkTheme, onChanged: (bool value) => store.trocarTema()),
        backgroundColor: Colors.green[500],
        title: const Text('Controle Financeiro'),
        centerTitle: true,
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              debugPrint('Botão de menu pressionado');
            },
            icon: Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            selectedIndex: paginaAtual,
            onDestinationSelected: (index) => setState(() => paginaAtual = index),
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.pie_chart, size: 30), label: Text('Dashboard', style: TextStyle(fontSize: 17))),
              NavigationRailDestination(icon: Icon(Icons.monetization_on_outlined, size: 30), label: Text('Lançamentos', style: TextStyle(fontSize: 17))),
              NavigationRailDestination(icon: Icon(Icons.settings, size: 30), label: Text('Configurações', style: TextStyle(fontSize: 17))),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: IndexedStack(index: paginaAtual, children: [...paginas])),
        ],
      ),
    );
  }
}
