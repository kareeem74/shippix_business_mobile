import 'package:dio/dio.dart';
import 'auth_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/api',
    receiveTimeout: const Duration(seconds: 3),
  ));

  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> createOrderRequest(Map<String, dynamic> data) async {
    try {
      final token = _authService.currentUserToken;
      if (token == null) {
        throw Exception('Authentication required: No access token found.');
      }
      final response = await _dio.post(
        '/order-requests',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        throw Exception('Failed to create order request: ${e.response?.data}');
      } else {
        print('Error sending request: ${e.message}');
        throw Exception('Failed to create order request: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> getShippingCost(int requestId) async {
    try {
      final token = _authService.currentUserToken;
      if (token == null) {
        throw Exception('Authentication required: No access token found.');
      }
      final response = await _dio.get(
        '/pricing/$requestId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        throw Exception('Failed to get shipping cost: ${e.response?.data}');
      } else {
        print('Error sending request: ${e.message}');
        throw Exception('Failed to get shipping cost: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(int orderRequestId) async {
    try {
      final token = _authService.currentUserToken;
      if (token == null) {
        throw Exception('Authentication required: No access token found.');
      }
      final response = await _dio.get(
        '/order-requests/$orderRequestId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
        throw Exception('Failed to get order details: ${e.response?.data}');
      } else {
        print('Error sending request: ${e.message}');
        throw Exception('Failed to get order details: ${e.message}');
      }
    }
  }
}
