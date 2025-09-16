import 'package:flutter/material.dart';
import 'package:shippix_mobile/features/home/ui/home_screen.dart';
import 'package:shippix_mobile/features/main/main_screen.dart';

class NewOrderScreen extends StatefulWidget {
  final bool showBackButton;
  const NewOrderScreen({super.key, this.showBackButton = false});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  bool _isCostCalculated = false;

  static const Color _primaryColor = Color(0xFF1C7364);

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
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
              Icon(icon, color: Colors.black54, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _primaryColor, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {String? hint, TextInputType type = TextInputType.text}) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        floatingLabelStyle: const TextStyle(color: _primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _primaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Order",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Add a customer order to your system",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information
            _buildSection(
              icon: Icons.person_outline,
              title: "Customer Information",
              subtitle: "Details about your customer",
              children: [
                _buildTextField("Customer Name"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Email Address", type: TextInputType.emailAddress)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField("Phone Number", type: TextInputType.phone)),
                  ],
                ),
              ],
            ),

            // Delivery Information
            _buildSection(
              icon: Icons.local_shipping_outlined,
              title: "Delivery Information",
              subtitle: "Where should we deliver this order?",
              children: [
                _buildTextField("Street Address"),
                const SizedBox(height: 12),
                _buildTextField("City"),
                const SizedBox(height: 12),
                _buildTextField("Notes to Driver (Optional)"),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Distance: 30Km",
                    style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            // Package Information
            _buildSection(
              icon: Icons.inventory_2_outlined,
              title: "Package Information",
              subtitle: "Details about what you are shipping",
              children: [
                _buildTextField("Items Description", hint: "e.g., Electronics, Clothing, Books"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Total Weight (kg)", type: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField("Package Value (EGP)", type: TextInputType.number)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Conditional UI Block
            if (!_isCostCalculated)
              _buildCalculateButton()
            else
              _buildCostResultAndNextButton(),
          ],
        ),
      ),
    );
  }

  // Calculate button
  Widget _buildCalculateButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF263238),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () => setState(() => _isCostCalculated = true),
          child: const Text("Calculate Shipping Cost", style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        const SizedBox(height: 8),
        const Text(
          "We take into account the Package Weight and Delivery Distance",
          style: TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCostResultAndNextButton() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.monetization_on_outlined, color: _primaryColor, size: 30),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Cost', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('\$0.00 EGP', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                ],
              ),
              const Spacer(),
              const Flexible(
                child: Text(
                  '15% Below Market, Stand Out from Competition!',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF263238),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () { //TODO: Navigate to payment screen},
            },
            child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}