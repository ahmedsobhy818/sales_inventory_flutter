// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.local/v1'));
    
    // Interceptor to emulate fetching static JSON data
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains('/dashboard')) {
            final mockJson = {
              "totalSales": 12450.50,
              "totalInventory": 3420,
              "monthlySales": [1200, 1900, 3000, 2500, 3800, 4200],
              "categories": [
                {"name": "Electronics", "qty": 1200},
                {"name": "Furniture", "qty": 800},
                {"name": "Apparel", "qty": 1420}
              ]
            };
            return handler.resolve(
              Response(
                requestOptions: options,
                data: mockJson,
                statusCode: 200,
              ),
            );
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final response = await dio.get('/dashboard');
    return response.data;
  }
}