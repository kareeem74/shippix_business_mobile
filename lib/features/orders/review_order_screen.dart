import 'package:flutter/material.dart';

class ReviewOrderScreen extends StatelessWidget {
  final String orderId;

  const ReviewOrderScreen({super.key, required this.orderId});

  static const Color _primaryColor = Color(0xFF1C7364);

  Widget _buildInfoCard(IconData icon, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 14))),
          Expanded(
              flex: 3,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Review Order",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black)),
            Text("Order #$orderId",
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Info
            _buildInfoCard(Icons.person_outline, "Customer Information", [
              _buildRow("Customer Name:", "Afnan Sayed"),
              _buildRow("Email Address:", "afnansayed04@gmail.com"),
              _buildRow("Phone Number:", "01065464044"),
              _buildRow("Order Date:", "14-5-2025"),
            ]),

            // Delivery Info
            _buildInfoCard(Icons.location_on_outlined, "Delivery Information", [
              _buildRow("Street Address:", "str1234"),
              _buildRow("City:", "QBA"),
              _buildRow("Total Distance:", "30 Km"),
            ]),

            // Package Info
            _buildInfoCard(Icons.inventory_2_outlined, "Package Information", [
              _buildRow("Items Description:", "Electronic Devices"),
              _buildRow("Total Weight:", "10 Kg"),
              _buildRow("Package Value (EGP):", "10,000"),
            ]),

            // Shipping Cost
            _buildInfoCard(Icons.attach_money, "Shipping Cost", [
              _buildRow("Cost:", "50.00 EGP"),
            ]),

            // Order Status
            _buildInfoCard(Icons.info_outline, "Order Status", [
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("processing",
                        style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  const Text("Awaiting review and approval",
                      style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              )
            ]),

            const SizedBox(height: 30),
            // Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF263238),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                // TODO: approve and create shipment logic
              },
              child: const Text("Approve & Create Shipment",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                // TODO: edit order details
              },
              child: const Text("Edit Order Details",
                style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                // TODO: save as draft
              },
              child: const Text("Save as Draft",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
