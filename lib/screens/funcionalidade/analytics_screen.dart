import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trabalho/services/lib/services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, Object?> data = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await AnalyticsService.getAllMetrics();
    setState(() => data = d);
  }

  Future<void> _reset() async {
    await AnalyticsService.resetAll();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório de Métricas')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // -------------------------
            // GRÁFICO DE BARRAS
            // -------------------------
            if (data.isNotEmpty)
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < 0 ||
                                value.toInt() >= keys.length) {
                              return const SizedBox();
                            }
                            final label =
                                keys[value.toInt()].replaceAll("_", "\n");
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(keys.length, (i) {
                      final key = keys[i];
                      final raw = data[key];

                      double valor;
                      if (raw == null) {
                        valor = 0;
                      } else if (raw is num) {
                        valor = raw.toDouble();
                      } else if (raw is String) {
                        valor = double.tryParse(raw) ??
                            (int.tryParse(raw)?.toDouble() ?? 0);
                      } else {
                        valor = 0;
                      }

                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: valor,
                            width: 22,
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.lightBlueAccent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // -------------------------
            // LISTA SIMPLES DE DADOS
            // -------------------------
            Expanded(
              child: keys.isEmpty
                  ? const Center(child: Text('Nenhuma métrica disponível'))
                  : ListView.separated(
                      itemCount: keys.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final k = keys[i];
                        final v = data[k];
                        return ListTile(
                          title: Text(k),
                          trailing: SizedBox(
                            width: 90,
                            child: Text(
                              v.toString(),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // BOTÕES
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _reset,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Resetar métricas'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _load,
                    child: const Text('Atualizar'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
