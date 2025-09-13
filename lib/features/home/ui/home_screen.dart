import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(String id, String route, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ID$id", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(route, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green.shade700,
            minHeight: 6,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Time Remaining",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
    return [
      _buildProfileMenuItem(),
      const PopupMenuDivider(),
      _buildSettingsMenuItem(),
      _buildMenuItem(Icons.help_outline, "Help"),
      _buildMenuItem(Icons.language, "Language"),
      _buildManageMenuItem(),
      _buildMenuItem(Icons.logout, "Logout"),
    ];
  }

  PopupMenuItem<String> _buildProfileMenuItem() {
    return PopupMenuItem<String>(
      enabled: false,
      child: Row(
        children: const [
          Icon(Icons.account_circle_outlined, size: 32),
          SizedBox(width: 12),
          Text(
            "Current User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildSettingsMenuItem() {
    return PopupMenuItem<String>(
      child: ListTile(
        leading: const Icon(Icons.settings_outlined),
        title: const Text("Settings"),
        subtitle: Text(
          "Settings and Privacy",
          style: TextStyle(color: Colors.green.shade700, fontSize: 12),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  PopupMenuItem<String> _buildManageMenuItem() {
    return PopupMenuItem<String>(
      child: ListTile(
        leading: const Icon(Icons.inventory_2),
        title: const Text("Manage"),
        subtitle: Text(
          "Your Orders",
          style: TextStyle(color: Colors.green.shade700, fontSize: 12),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String title) {
    return PopupMenuItem<String>(
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shippix-Business",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Create New Order"),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (String result) {},
            itemBuilder: _buildPopupMenuItems,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Top Stats
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildCard("Total Completed Orders", "40", Icons.inventory_2),
                _buildCard("Active", "5", Icons.location_on_outlined),
                _buildCard("Completed Today", "3", Icons.check_box_outlined),
                _buildCard("Pending Pickup", "0", Icons.local_shipping_outlined),
              ],
            ),

            const SizedBox(height: 24),

            // Active Shipments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Active Shipments",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("View All",
                    style: TextStyle(color: Colors.green, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            _buildShipmentCard("1", "Cairo → Alexandria", 0.7),
            _buildShipmentCard("2", "Cairo → Giza", 0.5),
            _buildShipmentCard("3", "Cairo → Aswan", 0.6),

            const SizedBox(height: 24),

            // Weekly Performance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("This Week's Performance",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  Text("Delivery Success Rate: 96%"),
                  Text("Average Delivery Time: 2 days"),
                  Text("Customer Satisfaction: 4.9/5"),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
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
