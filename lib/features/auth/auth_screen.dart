import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool rememberMe = false;
  bool obscurePassword = true;

  final _signInUsernameController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pickupController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpRePasswordController = TextEditingController();

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && obscurePassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Welcome Back!",
          style: TextStyle(fontSize: 20,),
        ),
        const SizedBox(height: 5),
        const Text(
            "Sign in to your business account",
            style: TextStyle(color: Colors.grey
            )
        ),
        const SizedBox(height: 30),
        _buildTextField(_signInUsernameController, "Username"),
        const SizedBox(height: 15),
        _buildTextField(_signInPasswordController, "Password", isPassword: true),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (val) {
                setState(() {
                  rememberMe = val ?? false;
                });
              },
            ),
            const Text("Remember me"),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot Password ?"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xFF116E5C),
          ),
          child: const Text(
              "Sign In",
              style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          )
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don’t have an account? "),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSignIn = false;
                });
              },
              child: const Text(
                "Register here",
                style: TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Create your Business Account",
            style: TextStyle(fontSize: 18,),
          ),
          const SizedBox(height: 5),
          const Text(
              "Join Shippix-Business to manage your shipping",
              style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _buildTextField(_businessNameController, "Business Name"),
          const SizedBox(height: 15),
          _buildTextField(_ownerNameController, "Owner Name"),
          const SizedBox(height: 15),
          _buildTextField(_emailController, "Email Address"),
          const SizedBox(height: 15),
          _buildTextField(_nationalIdController, "National ID"),
          const SizedBox(height: 15),
          _buildTextField(_phoneController, "Phone Number"),
          const SizedBox(height: 15),
          _buildTextField(_pickupController, "Pick Up Location"),
          const SizedBox(height: 15),
          _buildTextField(_businessTypeController, "Business Type"),
          const SizedBox(height: 15),
          _buildTextField(_signUpPasswordController, "Password", isPassword: true),
          const SizedBox(height: 15),
          _buildTextField(_signUpRePasswordController, "Confirm Password", isPassword: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xFF116E5C),
            ),
            child: const Text(
              "Create Business Account",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              )
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSignIn = true;
                  });
                },
                child: const Text(
                  "Login here",
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Image.asset('assets/images/shippix_logo.png', height: 180),
                  const SizedBox(height: 10),
                  const Text(
                    "Shippix-Business",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tabs
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal.shade50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignIn = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSignIn ? const Color(0xFF116E5C) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: isSignIn ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignIn = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isSignIn ? const Color(0xFF116E5C) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: !isSignIn ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: isSignIn ? _buildSignInForm() : _buildSignUpForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
