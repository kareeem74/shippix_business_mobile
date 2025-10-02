import 'package:dio/dio.dart';
import 'package:shippix_mobile/services/auth_service.dart'; // Import AuthService

class DioService {
  late Dio _dio;
  final AuthService _authService = AuthService(); // Initialize AuthService

  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/api', // Android emulator localhost
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _getAccessToken(); 
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        } else {

        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // TODO: Handle errors globally,
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  Future<String?> _getAccessToken() async {
    return _authService.currentUserToken;
  }
}