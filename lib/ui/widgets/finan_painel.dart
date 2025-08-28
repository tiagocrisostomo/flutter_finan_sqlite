import 'package:db_sqlite/utils/cores_aleatorias.dart';
import 'package:db_sqlite/viewmodel/finan_lancamento_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PainelFinanceiro extends StatefulWidget {
  const PainelFinanceiro({super.key});

  @override
  State<PainelFinanceiro> createState() => _PainelFinanceiroState();
}

class _PainelFinanceiroState extends State<PainelFinanceiro>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Por Tipo'),
    Tab(text: 'Por Categoria'),
    Tab(text: 'Por Titular'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoViewModel>(
        context,
        listen: false,
      ).carregarLancamentosMes();

      Provider.of<FinanLancamentoViewModel>(
        context,
        listen: false,
      ).totaisPorCategoriaDescricao();

      Provider.of<FinanLancamentoViewModel>(
        context,
        listen: false,
      ).totaisPorTipoDescricao();

      Provider.of<FinanLancamentoViewModel>(context, listen: false);
    });
  }

  // Método para carregar os dados

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final store = context.watch<FinanLancamentoViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Painel")),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCards('A Receber', store.totalAreceber),
          SizedBox(height: 16),
          _buildCards('A Pagar', store.totalApagar),
          SizedBox(height: 16),
          _buildCards('Saldo', store.saldoTotal),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            height: size.height * 0.06,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              dividerColor: Colors.grey[300],
              isScrollable: true,
              controller: _tabController,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabAlignment: TabAlignment.center,

              tabs: _tabs,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: size.height * 0.4,
            decoration: BoxDecoration(
              // color: Colors.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGraficoPizzaPorTipo(store),
                _buildGraficoPizzaCategoria(store),
                _buildGraficoPizzaPorTitular(store),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCards(String titulo, double valor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              (titulo == 'A Receber')
                  ? Icons.monetization_on_rounded
                  : (titulo == 'A Pagar')
                  ? Icons.money_off_csred
                  : Icons.attach_money_outlined,
              size: 32,
              color:
                  (titulo == 'A Receber')
                      ? Colors.green
                      : (titulo == 'A Pagar')
                      ? Colors.red
                      : (valor > 0)
                      ? Colors.blue
                      : Colors.orange,
            ),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const Spacer(),
            (valor > 0)
                ? Text(
                  'R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : Text(
                  'R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoPizzaPorTipo(FinanLancamentoViewModel store) {
    final data = store.totaisPorTipoDescricao();
    final total = data.values.fold(0.0, (a, b) => a + b);

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: PieChart(
          PieChartData(
            sections:
                data.entries.map((entry) {
                  final percent = (entry.value / total) * 100;
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${entry.key} \n ${percent.toStringAsFixed(2)}%',
                    color: corAleatoria(entry.key),
                    radius: 90,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: corAleatoria(entry.value.toString()),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGraficoPizzaCategoria(FinanLancamentoViewModel store) {
    final data = store.totaisPorCategoriaDescricao();
    final total = data.values.fold(0.0, (a, b) => a + b);

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: PieChart(
          PieChartData(
            sections:
                data.entries.map((entry) {
                  final percent = (entry.value / total) * 100;
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${entry.key} \n ${percent.toStringAsFixed(2)}%',
                    color: corAleatoria(entry.key),
                    radius: 90,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: corAleatoria(entry.value.toString()),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGraficoPizzaPorTitular(FinanLancamentoViewModel store) {
    final data = store.totaisPorUsuarioNome();
    final total = data.values.fold(0.0, (a, b) => a + b);

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: PieChart(
          PieChartData(
            sections:
                data.entries.map((entry) {
                  final percent = (entry.value / total) * 100;
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${entry.key} \n ${percent.toStringAsFixed(2)}%',
                    color: corAleatoria(entry.key),
                    radius: 90,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: corAleatoria(entry.value.toString()),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
