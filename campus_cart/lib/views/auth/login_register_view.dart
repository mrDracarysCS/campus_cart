import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/db/auth_service.dart';
import 'package:campus_cart/models/app_user.dart';

class LoginRegisterView extends StatefulWidget {
  final bool startInLogin;

  const LoginRegisterView({super.key, this.startInLogin = true});

  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {
  late bool isLogin;
  String selectedRole = "Student"; // Default role

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLogin = widget.startInLogin;
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _handleSubmit() async {
    if (!isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      _showMessage("Passwords do not match!", Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      AppUser? user;

      if (isLogin) {
        user = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        user = await AuthService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _usernameController.text.trim(),
          selectedRole == "Vendor" ? UserRole.vendor : UserRole.student,
        );
      }

      if (user == null) {
        _showMessage(
            isLogin ? "Login failed!" : "Registration failed!", Colors.red);
        return;
      }

      _showMessage(
          isLogin ? "Login successful!" : "Registration successful!",
          Colors.green);

      // Redirect based on role
      if (user.role == UserRole.vendor) {
        Navigator.pushReplacementNamed(context, '/vendor');
      } else {
        Navigator.pushReplacementNamed(context, '/student');
      }
    } catch (e) {
      _showMessage("Error: $e", Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLogin ? "Login Form" : "Register Form",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryDarkColor,
                ),
              ),
              const SizedBox(height: 20),

              // Toggle Buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _toggleButton("Login", isLogin, () {
                      setState(() => isLogin = true);
                    }),
                    _toggleButton("Signup", !isLogin, () {
                      setState(() => isLogin = false);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (!isLogin) ...[
                _buildTextField(
                    controller: _usernameController,
                    hint: "Username",
                    isPassword: false),
                const SizedBox(height: 12),

                // Role selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _roleOption("Student"),
                    const SizedBox(width: 10),
                    _roleOption("Vendor"),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              _buildTextField(
                  controller: _emailController,
                  hint: "Email Address",
                  isPassword: false),
              const SizedBox(height: 12),

              _buildTextField(
                  controller: _passwordController,
                  hint: "Password",
                  isPassword: true),

              if (!isLogin) ...[
                const SizedBox(height: 12),
                _buildTextField(
                    controller: _confirmPasswordController,
                    hint: "Confirm Password",
                    isPassword: true),
              ],

              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 14, color: Colors.purple[700]),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: kAccentLightColor,
                  foregroundColor: kPrimaryDarkColor,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        isLogin ? "Login" : "Register",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLogin
                      ? "Not a member?"
                      : "Already have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin ? "Signup now" : "Login here",
                      style: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleOption(String role) {
    final isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? kAccentLightColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(role,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? kPrimaryDarkColor : Colors.black87)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _toggleButton(String text, bool selected, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kAccentLightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected ? kPrimaryDarkColor : Colors.black87)),
        ),
      ),
    );
  }
}
