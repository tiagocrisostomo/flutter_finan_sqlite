import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:intl/intl.dart';

Future<Map<String, List<FinanLancamento>>> agruparPorMes(List<FinanLancamento> lancamentos) {
  final Map<String, List<FinanLancamento>> agrupado = {};
  final format = DateFormat('yyyy-MM');

  for (var l in lancamentos) {
    final chave = format.format(l.data!);
    agrupado.putIfAbsent(chave, () => []);
    agrupado[chave]!.add(l);
  }

  return Future.value(agrupado);
}
