import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _attemptAutoSignIn().then((_) {
      _authStateController.add(currentAuthStatus);
    });
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  final _storage = const FlutterSecureStorage();
  static String? _currentUserToken;
  static String? _refreshToken;
  static Timer? _refreshTokenTimer;

  String? get currentUserToken => _currentUserToken;

  static final BehaviorSubject<bool> _authStateController =
      BehaviorSubject<bool>();

  Stream<bool> get authStateChanges => _authStateController.stream;

  bool get currentAuthStatus => _currentUserToken != null;

  // method to attempt auto sign-in
  Future<void> _attemptAutoSignIn() async {
    _refreshToken = await _getRefreshToken();
    if (_refreshToken != null) {
      await _refreshTokenAccess(rememberMe: true);
    }
  }

  // method to save the refresh token
  Future<void> _saveRefreshToken(String token) async {
    await _storage.write(key: 'refreshToken', value: token);
  }

  // method to retrieve the refresh token
  Future<String?> _getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  // method to delete the refresh token
  Future<void> _deleteRefreshToken() async {
    await _storage.delete(key: 'refreshToken');
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

      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Sign Up Failed'));
    }
  }

  Future<Response> signIn({
    required String email,
    required String password,
    bool rememberMe = false, // Add rememberMe parameter
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
        _currentUserToken = response.data['accessToken'];
        _refreshToken = response.data['refreshToken'];
        if (_refreshToken != null && rememberMe) { // Only save if rememberMe is true
          await _saveRefreshToken(_refreshToken!); // Save the refresh token securely
        }
        _authStateController.add(true);
        _startTokenRefreshTimer(); // start refresh timer
      }
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Sign In Failed'));
    }
  }

  // method to verify mail
  Future<void> verifyMail({required String email}) async {
    try {
      final response = await _dio.post(
      '/api/auth/verifyMail/$email',
      );
      if (response.statusCode != 200) {
        throw Exception(
        'Failed to verify email. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Email Verification Failed'));
    }
  }

  // method to verifyOTP
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _dio.post(
        '/api/auth/verifyOtp/$email/$otp',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to verify OTP. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'OTP Verification Failed'));
    }
  }

  // method to edit the password
  Future<void> changePassword({
    required String email,
    required String newPassword,
    required String repeatPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/changePassword/$email',
        data: {
          "password": newPassword,
          "repeatPassword": repeatPassword,
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to change password. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Change Password Failed'));
    }
  }

  // method to signout
  void signOut() {
    _currentUserToken = null;
    _refreshToken = null;
    _refreshTokenTimer?.cancel();
    _authStateController.add(false);
    _deleteRefreshToken(); // Delete refresh token from secure storage
  }

  // method to start the periodic token refresh
  void _startTokenRefreshTimer() {
    _refreshTokenTimer?.cancel();
    _refreshTokenTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _refreshTokenAccess(rememberMe: true); // Pass rememberMe to _refreshTokenAccess
    });
  }

  // method to refresh the access token
  Future<void> _refreshTokenAccess({required bool rememberMe}) async {
    if (_refreshToken == null) {
      signOut(); // no refresh token, force sign out
      return;
    }

    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {
          "refreshToken": _refreshToken,
        },
      );

      if (response.statusCode == 200) {
        _currentUserToken = response.data['accessToken'];
        // Optionally, update _refreshToken if the API returns a new one
        if (response.data['refreshToken'] != null) {
          _refreshToken = response.data['refreshToken'];
          if (rememberMe) { // Only save if rememberMe is true
            await _saveRefreshToken(_refreshToken!); // Save the new refresh token
          }
        }
        _authStateController.add(true); // ensure auth state is true
      } else {
        signOut();
      }
    } on DioException catch (e) {
      print('Token refresh failed: ${_handleDioError(e, 'Token Refresh Failed')}');
      signOut(); // on error > sign out
    }
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
    _refreshTokenTimer?.cancel(); // cancel timer on dispose
  }
}
