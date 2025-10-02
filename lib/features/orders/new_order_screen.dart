import 'package:flutter/material.dart';
import 'package:shippix_mobile/features/orders/review_order_screen.dart';
import 'package:shippix_mobile/services/api_service.dart';

class NewOrderScreen extends StatefulWidget {
  final bool showBackButton;
  const NewOrderScreen({super.key, this.showBackButton = false});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCostCalculated = false;

  double? _calculatedPrice;
  String? _currency;
  double? _deliveryDistance;
  int? _orderRequestId; // To store the reqId for ReviewOrderScreen

  final ApiService _apiService = ApiService();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _notesToDriverController = TextEditingController();
  final TextEditingController _itemsDescriptionController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _packageValueController = TextEditingController();

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

  Widget _buildTextField(String label,
      {String? hint,
      TextInputType type = TextInputType.text,
      String? prefixText,
      String? Function(String?)? validator,
      required TextEditingController controller}) {
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        errorMaxLines: 2,
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _emailAddressController.dispose();
    _phoneNumberController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _notesToDriverController.dispose();
    _itemsDescriptionController.dispose();
    _totalWeightController.dispose();
    _packageValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.black, size: 20),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information
              _buildSection(
                icon: Icons.person_outline,
                title: "Customer Information",
                subtitle: "Details about your customer",
                children: [
                  _buildTextField("Customer Name",
                      controller: _customerNameController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a customer name';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'Customer name can only contain alphabetic characters and spaces';
                    }
                    return null;
                  }),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField("Email Address",
                              controller: _emailAddressController,
                              type: TextInputType.emailAddress,
                              validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      })),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildTextField("Phone Number",
                              controller: _phoneNumberController,
                              type: TextInputType.phone,
                              prefixText: "+20 ",
                              validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 11) {
                          return 'Phone number must be 11 digits';
                        }
                        return null;
                      })),
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
                  _buildTextField("Street Address",
                      controller: _streetAddressController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a street address';
                    }
                    return null;
                  }),
                  const SizedBox(height: 12),
                  _buildTextField("City",
                      controller: _cityController,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                      return 'City can only contain alphabetic characters and spaces';
                    }
                    return null;
                  }),
                  const SizedBox(height: 12),
                  _buildTextField("Notes to Driver (Optional)",
                      controller: _notesToDriverController),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _deliveryDistance != null
                          ? "Total Distance: ${_deliveryDistance!.toStringAsFixed(2)}Km"
                          : "Total Distance: N/A",
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
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
                  _buildTextField("Items Description",
                      controller: _itemsDescriptionController,
                      hint: "e.g., Electronics, Clothing, Books",
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item(s) description';
                    }
                    return null;
                  }),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField("Total Weight (kg)",
                              controller: _totalWeightController,
                              type: TextInputType.number, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      })),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildTextField("Package Value (EGP)",
                              controller: _packageValueController,
                              type: TextInputType.number, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      })),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (!_isCostCalculated)
                _buildCalculateButton()
              else
                _buildCostResultAndNextButton(),
            ],
          ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calculating shipping cost...')),
              );

              try {
                // In a real application, these would come from a location picker/service
                double fromLatitude = 40.7128;
                double fromLongitude = -74.0060;
                double toLatitude = 40.7589;
                double toLongitude = -73.9851;

                final orderRequestData = {
                  "orderDescription": _itemsDescriptionController.text,
                  "notesToDriver": _notesToDriverController.text.isEmpty ? null : _notesToDriverController.text,
                  "packageWeight": double.parse(_totalWeightController.text),
                  "packageValue": double.parse(_packageValueController.text),
                  "fromLatitude": fromLatitude,
                  "fromLongitude": fromLongitude,
                  "toLatitude": toLatitude,
                  "toLongitude": toLongitude,
                  "custName": _customerNameController.text,
                  "custPhoneNumber": _phoneNumberController.text,
                  "custEmail": _emailAddressController.text,
                };

                final createOrderResponse =
                    await _apiService.createOrderRequest(orderRequestData);
                final reqId = createOrderResponse['reqId'];
                final deliveryDistance = createOrderResponse['deliveryDistance'];

                if (reqId != null) {
                  final pricingResponse =
                      await _apiService.getShippingCost(reqId);
                  setState(() {
                    _calculatedPrice = (pricingResponse['calculatedPrice'] as num?)?.toDouble() ?? 0.0;
                    _currency = pricingResponse['currency'] as String?;
                    _deliveryDistance = deliveryDistance?.toDouble();
                    _orderRequestId = reqId;
                    _isCostCalculated = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shipping cost calculated successfully!')),
                  );
                } else {
                   throw Exception('Failed to get request ID from order creation.');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
                setState(() {
                  _isCostCalculated = false;
                });
              }
            }
          },
          child: const Text("Calculate Shipping Cost",
              style: TextStyle(fontSize: 16, color: Colors.white)),
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
              Icon(Icons.monetization_on_outlined,
                  color: _primaryColor, size: 30),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shipping Cost',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                    _calculatedPrice != null && _currency != null
                        ? '${_calculatedPrice!.toStringAsFixed(2)} ${_currency!}'
                        : 'N/A',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              if (_orderRequestId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewOrderScreen(orderId: _orderRequestId!), // Pass actual order ID
                  ),
                );
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order ID not available. Please calculate shipping cost first.')),
                );
              }
            },
            child: const Text("Next",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}