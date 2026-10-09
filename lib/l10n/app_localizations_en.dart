// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sales & Inventory';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get reports => 'Reports';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get inventoryQty => 'Inventory Quantities';

  @override
  String get salesTrend => 'Sales Trend';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get generateReport => 'Generate Report';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get language => 'Language';

  @override
  String get reportType => 'Report Type';

  @override
  String get salesReport => 'Sales Report';

  @override
  String get inventorySummary => 'Inventory Summary';

  @override
  String get generateExportReport => 'Generate & Export Report';
}
