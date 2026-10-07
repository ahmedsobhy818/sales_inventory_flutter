// lib/views/report_search_screen.dart
import 'package:flutter/material.dart';
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
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _reportType,
                decoration: const InputDecoration(labelText: 'Report Type'),
                items: const [
                  DropdownMenuItem(value: 'Sales', child: Text('Sales Report')),
                  DropdownMenuItem(value: 'Inventory', child: Text('Inventory Summary')),
                ],
                onChanged: (val) => setState(() => _reportType = val!),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate & Export Report'),
                onPressed: _generateAndPreviewPdf,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateAndPreviewPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('DevExpress Exported Report', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 12),
                pw.Text('Report Type: $_reportType'),
                pw.Text('Generated on: ${DateTime.now().toIso8601String()}'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}