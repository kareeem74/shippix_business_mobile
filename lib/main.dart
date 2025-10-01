import 'package:flutter/material.dart';
import 'package:shippix_mobile/features/auth/auth_screen.dart';
import 'package:shippix_mobile/features/other/loading_screen.dart';
import 'package:shippix_mobile/services/auth_service.dart';
import 'features/main/main_screen.dart';

// Global instance of AuthService
final AuthService authService = AuthService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shippix Business',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StreamBuilder<bool>(
        stream: authService.authStateChanges,
        initialData: authService.currentAuthStatus, // seeded state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.data == true) {
            return const MainScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}