import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportSearchScreen extends StatefulWidget {
  const ReportSearchScreen({super.key});

  @override
  State<ReportSearchScreen> createState() => _ReportSearchScreenState();
}

class _ReportSearchScreenState extends State<ReportSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  String _reportType = 'Sales';
  String _selectedRange = 'Monthly';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final Map<String, List<double>> _chartData = {
    'Daily': [120, 180, 240, 190, 280, 260, 330],
    'Weekly': [820, 960, 880, 1100, 1250, 1190, 1380],
    'Monthly': [1500, 2200, 1800, 2600, 2400, 3100, 2900],
  };

  final Map<String, Map<String, num>> _summary = {
    'Daily': {'total': 1540, 'orders': 94, 'avg': 16.38, 'profit': 420},
    'Weekly': {'total': 8240, 'orders': 512, 'avg': 16.09, 'profit': 2130},
    'Monthly': {'total': 28600, 'orders': 1835, 'avg': 15.59, 'profit': 7600},
  };

  final List<Map<String, dynamic>> _rows = [
    {'item': 'Laptop', 'qty': 12, 'amount': 4200},
    {'item': 'Monitor', 'qty': 18, 'amount': 3600},
    {'item': 'Chair', 'qty': 25, 'amount': 2200},
    {'item': 'Printer', 'qty': 8, 'amount': 1800},
    {'item': 'Accessories', 'qty': 42, 'amount': 1600},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = _summary[_selectedRange] ?? _summary['Monthly']!;
    final chartValues = _chartData[_selectedRange] ?? _chartData['Monthly']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: l10n.exportPdf,
            onPressed: _generateAndPreviewPdf,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _reportType,
                  decoration: InputDecoration(
                    labelText: l10n.reportType,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    DropdownMenuItem(value: 'Sales', child: Text(l10n.salesReport)),
                    DropdownMenuItem(value: 'Inventory', child: Text(l10n.inventorySummary)),
                  ],
                  onChanged: (val) => setState(() => _reportType = val ?? 'Sales'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: l10n.startDate,
                        date: _startDate,
                        onTap: () => _pickDate(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: l10n.endDate,
                        date: _endDate,
                        onTap: () => _pickDate(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Daily', label: Text('Daily')),
                    ButtonSegment(value: 'Weekly', label: Text('Weekly')),
                    ButtonSegment(value: 'Monthly', label: Text('Monthly')),
                  ],
                  selected: {_selectedRange},
                  onSelectionChanged: (selection) => setState(() => _selectedRange = selection.first),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _SummaryCard(title: l10n.totalSales, value: '\$${summary['total']}', accent: Colors.indigo),
                    _SummaryCard(title: 'Orders', value: '${summary['orders']}', accent: Colors.green),
                    _SummaryCard(title: 'Avg. Order', value: '\$${summary['avg']}', accent: Colors.orange),
                    _SummaryCard(title: 'Profit', value: '\$${summary['profit']}', accent: Colors.purple),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales trend',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                    if (value >= 0 && value < labels.length) {
                                      return Text(labels[value.toInt()]);
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartValues
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                                    .toList(),
                                isCurved: true,
                                gradient: const LinearGradient(
                                  colors: [Colors.indigo, Colors.cyan],
                                ),
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.indigo.withAlpha(51), Colors.cyan.withAlpha(13)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Recent items',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 8)],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _rows.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = _rows[index];
                      return ListTile(
                        title: Text(row['item']),
                        subtitle: Text('${row['qty']} units'),
                        trailing: Text('\$${row['amount']}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _generateAndPreviewPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(l10n.generateExportReport),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(bool isStartDate) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selected == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = selected;
      } else {
        _endDate = selected;
      }
    });
  }

  Future<void> _generateAndPreviewPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('DevExpress Exported Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Report Type: $_reportType'),
              pw.Text('Range: $_selectedRange'),
              pw.Text('Start: ${_startDate.toLocal().toString().split(' ').first}'),
              pw.Text('End: ${_endDate.toLocal().toString().split(' ').first}'),
              pw.SizedBox(height: 18),
              pw.TableHelper.fromTextArray(
                headers: ['Item', 'Qty', 'Amount'],
                data: _rows.map((row) => [row['item'], row['qty'].toString(), '\$${row['amount']}']).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _SummaryCard({required this.title, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withAlpha(31),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withAlpha(64)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            Text(
              date.toLocal().toString().split(' ').first,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}