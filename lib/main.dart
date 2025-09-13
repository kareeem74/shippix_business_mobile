import 'package:flutter/material.dart';
import 'features/auth/auth_screen.dart';
import 'features/home/ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // remove the debug banner
      title: 'Shippix Business',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AuthScreen(),
    );
  }
}
