// lib/providers/dashboard_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  Map<String, dynamic>? _data;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get data => _data;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _data = await _apiService.fetchDashboardData();
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}