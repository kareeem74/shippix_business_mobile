import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shippix_mobile/main.dart'; // Import global authService

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool _isLoading = false;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // controllers for password reset
  final _emailControllerForReset = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpRePasswordController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isResetLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureRepeatPassword = true;

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _businessTypeController.dispose();
    _signUpPasswordController.dispose();
    _signUpRePasswordController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _emailControllerForReset.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String hint, {
        bool isPassword = false,
        String? Function(String?)? validator,
        TextInputType keyboardType = TextInputType.text,
        bool? currentObscureText,
        VoidCallback? onSuffixIconPressed,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && (currentObscureText ?? obscurePassword),
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            (currentObscureText ?? obscurePassword) ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onSuffixIconPressed ?? () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    _emailControllerForReset.clear(); // Clear previous input
    setState(() {
      _isResetLoading = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enter your email to receive a verification code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  _buildTextFormField(
                    _emailControllerForReset,
                    "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isResetLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_emailControllerForReset.text.isEmpty || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailControllerForReset.text)) {
                        _showSnackBar("Please enter a valid email address.", isError: true);
                        return;
                      }

                      modalSetState(() {
                        _isResetLoading = true;
                      });
                      try {
                        await authService.verifyMail(email: _emailControllerForReset.text);
                        if (!mounted) return;
                        Navigator.pop(context); // Close email dialog
                        _showOtpDialog(_emailControllerForReset.text); // Show OTP dialog
                        _showSnackBar("Verification code sent to your email.");
                      } catch (e) {
                        _showSnackBar(e.toString(), isError: true);
                      } finally {
                        modalSetState(() {
                          _isResetLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF1C7364),
                    ),
                    child: const Text(
                      "Send Code",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showOtpDialog(String email) {
    _otpController.clear();
    setState(() {
      _isResetLoading = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enter OTP",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Please enter the 6-digit code sent to $email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  _buildTextFormField(
                    _otpController,
                    "OTP",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isResetLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_otpController.text.isEmpty || _otpController.text.length != 6) {
                        _showSnackBar("Please enter a valid 6-digit OTP.", isError: true);
                        return;
                      }

                      modalSetState(() {
                        _isResetLoading = true;
                      });
                      try {
                        await authService.verifyOtp(email: email, otp: _otpController.text);
                        if (!mounted) return;
                        Navigator.pop(context); // Close OTP dialog
                        _showChangePasswordDialog(email); // Show change password dialog
                        _showSnackBar("OTP Verified Successfully.");
                      } catch (e) {
                        _showSnackBar(e.toString(), isError: true);
                      } finally {
                        modalSetState(() {
                          _isResetLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF1C7364),
                    ),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePasswordDialog(String email) {
    _newPasswordController.clear();
    _repeatPasswordController.clear();
    setState(() {
      _isResetLoading = false;
      _obscureNewPassword = true;
      _obscureRepeatPassword = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Set New Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enter your new password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  _buildTextFormField(
                    _newPasswordController,
                    "New Password",
                    isPassword: true,
                    currentObscureText: _obscureNewPassword,
                    onSuffixIconPressed: () {
                      modalSetState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextFormField(
                    _repeatPasswordController,
                    "Repeat New Password",
                    isPassword: true,
                    currentObscureText: _obscureRepeatPassword,
                    onSuffixIconPressed: () {
                      modalSetState(() {
                        _obscureRepeatPassword = !_obscureRepeatPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please repeat your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isResetLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_newPasswordController.text.isEmpty || _newPasswordController.text.length < 6) {
                        _showSnackBar("Please enter a new password (at least 6 characters).", isError: true);
                        return;
                      }
                      if (_newPasswordController.text != _repeatPasswordController.text) {
                        _showSnackBar("Passwords do not match.", isError: true);
                        return;
                      }

                      modalSetState(() {
                        _isResetLoading = true;
                      });
                      try {
                        await authService.changePassword(
                          email: email,
                          newPassword: _newPasswordController.text,
                          repeatPassword: _repeatPasswordController.text,
                        );
                        if (!mounted) return;
                        Navigator.pop(context); // Close change password dialog
                        _showSnackBar("Password changed successfully! You can now sign in with your new password.");
                      } catch (e) {
                        _showSnackBar(e.toString(), isError: true);
                      } finally {
                        modalSetState(() {
                          _isResetLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF1C7364),
                    ),
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 5),
            const Text(
              "Sign in to your business account",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildTextFormField(
              _signInEmailController,
              "Email",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _signInPasswordController,
              "Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
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
                  onPressed: () {
                    _showForgotPasswordDialog();
                  },
                  child: const Text("Forgot Password ?"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                if (_signInFormKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final response = await authService.signIn(
                      email: _signInEmailController.text,
                      password: _signInPasswordController.text,
                      rememberMe: rememberMe,
                    );
                    _showSnackBar('Sign In Successful');
                  } catch (e) {
                    _showSnackBar(e.toString(), isError: true);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF1C7364),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
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
                        color: Color(0xFF1C7364),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            const Text(
              "Join Shippix-Business to manage your shipping",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              _businessNameController,
              "Business Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your business name';
                }
                if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                  return 'Please enter characters only';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _ownerNameController,
              "Owner Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your owner name';
                }
                if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                  return 'Please enter characters only';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _emailController,
              "Email Address",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(_nationalIdController, "National ID"),
            const SizedBox(height: 15),
            _buildTextFormField(
              _phoneController,
              "Phone Number",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
                  return 'Please enter numbers only';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(_businessTypeController, "Business Type"),
            const SizedBox(height: 15),
            _buildTextFormField(
              _latitudeController,
              "Latitude",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter latitude';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _longitudeController,
              "Longitude",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter longitude';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _signUpPasswordController,
              "Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildTextFormField(
              _signUpRePasswordController,
              "Confirm Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _signUpPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                if (_signUpFormKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final response = await authService.signUp(
                      businessName: _businessNameController.text,
                      ownerName: _ownerNameController.text,
                      email: _emailController.text,
                      nationalId: _nationalIdController.text,
                      phoneNumber: _phoneController.text,
                      latitude: double.parse(_latitudeController.text),
                      longitude: double.parse(_longitudeController.text),
                      businessType: _businessTypeController.text,
                      password: _signUpPasswordController.text,
                      confirmPassword: _signUpRePasswordController.text,
                    );
                    _showSnackBar(
                        'Sign Up Successful: ${response.data}');
                    setState(() {
                      isSignIn = true;
                    });
                  } catch (e) {
                    _showSnackBar(e.toString(), isError: true);
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color(0xFF1C7364),
              ),
              child: const Text(
                "Create Business Account",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                        color: Color(0xFF1C7364),
                        fontWeight: FontWeight.bold),
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
                      color: Colors.black87,
                    ),
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
                            color: isSignIn
                                ? const Color(0xFF1C7364)
                                : Colors.transparent,
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
                            color: !isSignIn
                                ? const Color(0xFF1C7364)
                                : Colors.transparent,
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
