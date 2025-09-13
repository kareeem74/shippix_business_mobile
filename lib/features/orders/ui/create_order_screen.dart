import 'package:flutter/material.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87, size: 20),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {TextInputType type = TextInputType.text}) {
    return TextField(
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Order",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add a customer order to your system",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Customer Information
            _buildSection(
              icon: Icons.person_outline,
              title: "Customer Information",
              subtitle: "Details about your customer",
              children: [
                _buildTextField("Customer Name"),
                const SizedBox(height: 10),
                _buildTextField("Email Address",
                    type: TextInputType.emailAddress),
                const SizedBox(height: 10),
                _buildTextField("Phone Number",
                    type: TextInputType.phone),
              ],
            ),

            // Delivery Information
            _buildSection(
              icon: Icons.location_on_outlined,
              title: "Delivery Information",
              subtitle: "Where should we deliver this order?",
              children: [
                _buildTextField("Street Address"),
                const SizedBox(height: 10),
                _buildTextField("City"),
                const SizedBox(height: 10),
                _buildTextField("Notes to Driver (Optional)"),
                const SizedBox(height: 10),
                const Text(
                  "Total Distance: 30Km",
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ],
            ),

            // Package Information
            _buildSection(
              icon: Icons.inventory_2_outlined,
              title: "Package Information",
              subtitle: "Details about what you are shipping",
              children: [
                _buildTextField("Items Description (e.g., Electronics, Clothes, Books)"),
                const SizedBox(height: 10),
                _buildTextField("Total Weight (kg)",
                    type: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField("Package Value (EGP)",
                    type: TextInputType.number),
              ],
            ),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: Add logic here later
                },
                child: const Text(
                  "Calculate Shipping Cost",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                "We take into account the Package Weight and Delivery Distance",
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
