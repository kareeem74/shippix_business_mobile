import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';
import '../home/ui/home_screen.dart';
import '../orders/new_order_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isLoggedIn;
  const MainScreen({super.key, required this.isLoggedIn});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const NewOrderScreen(showBackButton: false),
    const Center(child: Text("Support Screen")),
    const Center(child: Text("Account Screen")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If not logged
    if (!widget.isLoggedIn) {
      return const AuthScreen();
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1C7364),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: "New Order"),
          BottomNavigationBarItem(
              icon: Icon(Icons.support_agent), label: "Support"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Account"),
        ],
      ),
    );
  }
}
