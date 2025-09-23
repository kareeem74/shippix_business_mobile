import 'package:flutter/material.dart';
import 'package:shippix_mobile/features/orders/order_status_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;

  const PaymentScreen({super.key, required this.orderId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String _selectedMethod = "Visa Card";

  static const Color _primaryColor = Color(0xFF1C7364);

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController vodafoneCashController = TextEditingController();

  Widget _buildInfoCard(String title, List<Widget> children) {
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
              color: _selectedMethod == method
                  ? Colors.green
                  : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),

        child: Row(
          children: [
            Icon(
              _selectedMethod == method
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedMethod == method
                  ? Colors.green
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(method,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, {
        String? hint,
        TextInputType type = TextInputType.text,
        String? prefixText,
        String? Function(String?)? validator,
        TextEditingController? controller,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
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
        errorMaxLines: 2,
      ),
      validator: validator,
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
            const Text("Payment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black)),
            Text("Order #${widget.orderId}",
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Payment Summary
            _buildInfoCard("Payment Summary", [
              Row(
                children: [
                  Text("Order: ",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black)),

                  Text("#${widget.orderId}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Shipping Cost:",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text("50.00 EGP",
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ]),

            // Payment Method
            _buildInfoCard("Select Payment Method", [
              Text("Choose Your Preferred Payment Option",
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 10,),
              _buildPaymentOption("Visa Card"),
              _buildPaymentOption("Fawry"),
              _buildPaymentOption("Vodafone Cash"),
            ]),

            // Payment Details
            if (_selectedMethod == "Visa Card")
              _buildInfoCard("Payment Details", [
                const SizedBox(height: 15,),
                _buildTextField(
                    "Card Number",
                    controller: cardNumberController,
                    type: TextInputType.number),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField(
                            "Expiry Date (MM/YY)",
                            controller: expiryDateController,
                            type: TextInputType.datetime)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildTextField(
                            "CVV",
                            controller: cvvController,
                            type: TextInputType.number)),
                  ],
                )
              ])
            else if (_selectedMethod == "Fawry")
              _buildInfoCard("Payment Details", [
                const SizedBox(height: 15,),
                const Text(
                    "You will receive a payment code to complete your payment at any Fawry location.",
                    style: TextStyle(fontSize: 14, color: Colors.black54))
              ])
            else if (_selectedMethod == "Vodafone Cash")
                _buildInfoCard("Payment Details", [
                  const SizedBox(height: 15,),
                  _buildTextField(
                      "Vodafone Cash Number",
                      controller: vodafoneCashController,
                      type: TextInputType.phone),
                ]),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF263238),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const OrderStatusScreen(orderId: "ORD-Afnan-1234", customer: 'Afnan Sayed', status: 'Awaiting Approval', deliveryAddress: "Alexandria"),
                  ),
                );
              },
              child: const Text("Pay 50.00 EGP",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
