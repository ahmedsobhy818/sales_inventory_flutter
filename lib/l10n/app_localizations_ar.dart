// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المبيعات والمخزون';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get reports => 'التقارير';

  @override
  String get totalSales => 'إجمالي المبيعات';

  @override
  String get inventoryQty => 'كميات المخزون';

  @override
  String get salesTrend => 'اتجاه المبيعات';

  @override
  String get startDate => 'تاريخ البداية';

  @override
  String get endDate => 'تاريخ النهاية';

  @override
  String get generateReport => 'إنشاء التقرير';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get language => 'اللغة';

  @override
  String get reportType => 'نوع التقرير';

  @override
  String get salesReport => 'تقرير المبيعات';

  @override
  String get inventorySummary => 'ملخص المخزون';

  @override
  String get generateExportReport => 'إنشاء وتصدير التقرير';
}
