// lib/views/report_search_screen.dart
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
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reports)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _reportType,
                decoration: InputDecoration(labelText: l10n.reportType),
                items: [
                  DropdownMenuItem(value: 'Sales', child: Text(l10n.salesReport)),
                  DropdownMenuItem(value: 'Inventory', child: Text(l10n.inventorySummary)),
                ],
                onChanged: (val) => setState(() => _reportType = val!),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(l10n.generateExportReport),
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