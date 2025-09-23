import 'package:flutter/material.dart';
import 'features/main/main_screen.dart';
import 'features/orders/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shippix Business',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainScreen(
        isLoggedIn: true,
      ),
    );
  }
}
