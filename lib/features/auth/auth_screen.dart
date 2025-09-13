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

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

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

  Widget _buildTextFormField(
      TextEditingController controller, String hint,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && obscurePassword,
      validator: validator,
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
    return Form(
      key: _signInFormKey,
      child: Column(
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
          _buildTextFormField(_signInUsernameController, "Username",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              }),
          const SizedBox(height: 15),
          _buildTextFormField(_signInPasswordController, "Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              }),
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
              onPressed: () {
                if (_signInFormKey.currentState!.validate()) {
                  // TODO: Implement sign in logic
                }
              },
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
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: SingleChildScrollView(
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
            _buildTextFormField(_businessNameController, "Business Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your business name';
                  }
                  if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                    return 'Please enter characters only';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            _buildTextFormField(_ownerNameController, "Owner Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your owner name';
                  }
                  if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                    return 'Please enter characters only';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            _buildTextFormField(_emailController, "Email Address",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            _buildTextFormField(_nationalIdController, "National ID"),
            const SizedBox(height: 15),
            _buildTextFormField(_phoneController, "Phone Number",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
                    return 'Please enter numbers only';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            _buildTextFormField(_pickupController, "Pick Up Location"),
            const SizedBox(height: 15),
            _buildTextFormField(_businessTypeController, "Business Type"),
            const SizedBox(height: 15),
            _buildTextFormField(_signUpPasswordController, "Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                }),
            const SizedBox(height: 15),
            _buildTextFormField(
                _signUpRePasswordController, "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _signUpPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_signUpFormKey.currentState!.validate()) {
                  // TODO: Implement sign up logic
                }
              },
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
