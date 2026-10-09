// lib/views/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/dashboard_provider.dart';
import '../providers/locale_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DashboardProvider>().loadDashboard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(provider.data, l10n),
                  const SizedBox(height: 24),
                  Text(
                    l10n.salesTrend,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 220, child: _buildLineChart(provider.data)),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic>? data, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(l10n.totalSales),
                  const SizedBox(height: 8),
                  Text('\$${data?['totalSales'] ?? 0}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(l10n.inventoryQty),
                  const SizedBox(height: 8),
                  Text('${data?['totalInventory'] ?? 0}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(Map<String, dynamic>? data) {
    final List<dynamic> sales = data?['monthlySales'] ?? [];
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: sales
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), (e.value as num).toDouble()))
                .toList(),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}