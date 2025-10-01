import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart'; // BehaviorSubject

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  String? _currentUserToken;

  final BehaviorSubject<bool> _authStateController =
  BehaviorSubject<bool>.seeded(false);

  Stream<bool> get authStateChanges => _authStateController.stream;

  bool get currentAuthStatus => _currentUserToken != null;

  AuthService() {
    _authStateController.add(currentAuthStatus);
  }

  Future<Response> signUp({
    required String businessName,
    required String ownerName,
    required String email,
    required String nationalId,
    required String phoneNumber,
    required double latitude,
    required double longitude,
    required String businessType,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          "businessName": businessName,
          "name": ownerName,
          "email": email,
          "nationalId": nationalId,
          "phoneNumber": phoneNumber,
          "latitude": latitude,
          "longitude": longitude,
          "businessType": businessType,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _currentUserToken = response.data['token'];
        _authStateController.add(true);
      }
      return response;
    } on DioException catch (e) {
      print('DioException during signUp: ${e.response?.data ?? e.message}');
      throw Exception(_handleDioError(e, 'Sign Up Failed'));
    }
  }

  Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        _currentUserToken = response.data['token'];
        _authStateController.add(true);
      }
      return response;
    } on DioException catch (e) {
      print('DioException during signIn: ${e.response?.data ?? e.message}');
      throw Exception(_handleDioError(e, 'Sign In Failed'));
    }
  }

  void signOut() {
    _currentUserToken = null;
    _authStateController.add(false);
  }

  String _handleDioError(DioException e, String defaultMsg) {
    if (e.response != null) {
      if (e.response!.data is String) {
        return e.response!.data;
      } else if (e.response!.data is Map &&
          e.response!.data.containsKey('message')) {
        return e.response!.data['message'];
      } else {
        return '$defaultMsg: ${e.response?.data ?? e.message}';
      }
    } else {
      return 'Failed to connect to the server';
    }
  }

  void dispose() {
    _authStateController.close();
  }
}