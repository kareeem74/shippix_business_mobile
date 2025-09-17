import 'package:flutter/material.dart';

class OrderStatusScreen extends StatelessWidget {
  final String orderId;
  final String customer;
  final String status;
  final String deliveryAddress;

  const OrderStatusScreen({
    super.key,
    required this.orderId,
    required this.customer,
    required this.status,
    required this.deliveryAddress,
  });

  static const Color _primaryColor = Color(0xFF1C7364);

  Widget _buildStep(String title, String description, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_checked,
            color: isCompleted ? Colors.green : _primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(description,
                    style: TextStyle(
                        fontSize: 13, color: isCompleted ? Colors.green : Colors.black87,)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54))),
          Expanded(
              flex: 3,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Status",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black)),
            Text("Order #$orderId",
                style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Shipping Progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep("Payment Confirmed",
                      "Payment has been processed successfully", true),
                  _buildStep("Awaiting Approval",
                      "Order under review by our shipping team", true),
                  _buildStep(
                      "Approved & Ready",
                      "Order approved and ready for shipping",
                      false),
                  _buildStep("Pickup Scheduled",
                      "Carrier pickup has been scheduled", false),
                  _buildStep("In Transit",
                      "Package is on its way to destination", false),
                  _buildStep(
                      "Shipped", "Package delivered successfully", false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderDetail("Customer:", customer),
                  _buildOrderDetail("Order ID:", "#$orderId"),
                  _buildOrderDetail("Status:", status),
                  _buildOrderDetail("Delivery Address:", deliveryAddress),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF263238),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Dashboard",
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
                // TODO: contact support logic
              },
              child: const Text("Contact Support",
                style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
