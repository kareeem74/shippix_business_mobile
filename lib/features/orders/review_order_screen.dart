import 'package:flutter/material.dart';
import 'package:shippix_mobile/features/orders/payment_screen.dart';
import 'package:shippix_mobile/services/api_service.dart';

class ReviewOrderScreen extends StatefulWidget {
  final int orderId;

  const ReviewOrderScreen({super.key, required this.orderId});

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  Map<String, dynamic>? _orderDetails;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    print('Fetching order details for ID: ${widget.orderId}'); // Added print statement
    try {
      final data = await _apiService.getOrderDetails(widget.orderId);
      print('Order details fetched: $data'); // Added print statement
      setState(() {
        _orderDetails = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load order details: $e')),
      );
    }
  }

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
            Text("Order #${widget.orderId.toString()}",
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orderDetails == null
          ? const Center(child: Text('Failed to load order details.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Info
            _buildInfoCard(Icons.person_outline, "Customer Information", [
              _buildRow("Customer Name:", _orderDetails?['custName'] ?? 'N/A'),
              _buildRow("Email Address:", _orderDetails?['custEmail'] ?? 'N/A'),
              _buildRow("Phone Number:", _orderDetails?['custPhoneNumber'] ?? 'N/A'),
              _buildRow("Order Date:", _orderDetails?['reviewedAt'] ?? 'N/A'),
            ]),

            // Delivery Info
            _buildInfoCard(Icons.location_on_outlined, "Delivery Information", [
              // From and To latitude/longitude are not directly mapped to display, assuming they are used for distance calculation
              _buildRow("Total Distance:", "${_orderDetails?['deliveryDistance'] ?? 'N/A'} Km"),
            ]),

            // Package Info
            _buildInfoCard(Icons.inventory_2_outlined, "Package Information", [
              _buildRow("Items Description:", _orderDetails?['orderDescription'] ?? 'N/A'),
              _buildRow("Total Weight:", "${_orderDetails?['packageWeight'] ?? 'N/A'} Kg"),
              _buildRow("Package Value (EGP):", "${_orderDetails?['packageValue'] ?? 'N/A'}"),
            ]),

            // Shipping Cost
            _buildInfoCard(Icons.attach_money, "Shipping Cost", [
              _buildRow("Cost:", "${_orderDetails?['calculatedPrice'] ?? 'N/A'} EGP"),
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
                    child: Text(_orderDetails?['decision'] ?? 'N/A',
                        style: const TextStyle(color: Colors.green, fontSize: 12)),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(orderId: widget.orderId.toString()),
                  ),
                );
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
