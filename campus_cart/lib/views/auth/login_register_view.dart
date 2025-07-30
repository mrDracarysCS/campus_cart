import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/db/auth_service.dart';
import 'package:campus_cart/views/home_view.dart';
import 'package:campus_cart/models/app_user.dart';

class LoginRegisterView extends StatefulWidget {
  final bool startInLogin;

  const LoginRegisterView({super.key, this.startInLogin = true});

  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {
  late bool isLogin;
  String selectedRole = "Student";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    isLogin = widget.startInLogin;
  }

  Future<void> _handleSubmit() async {
    if (!isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppUser? user;
    if (isLogin) {
      user = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      user = await AuthService.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        selectedRole == "Student" ? UserRole.student : UserRole.vendor,
      );
    }

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login/Register failed!"),
          backgroundColor: Colors.red,
        ),
      );
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
              _toggleButtons(),
              const SizedBox(height: 20),

              if (!isLogin) _usernameField(),
              if (!isLogin) const SizedBox(height: 12),
              if (!isLogin) _roleSelection(),

              _emailField(),
              const SizedBox(height: 12),

              _passwordField(),

              if (!isLogin) const SizedBox(height: 12),
              if (!isLogin) _confirmPasswordField(),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: kAccentLightColor,
                  foregroundColor: kPrimaryDarkColor,
                ),
                child: Text(
                  isLogin ? "Login" : "Register",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _toggleButton("Login", isLogin, () => setState(() => isLogin = true)),
          _toggleButton("Signup", !isLogin, () => setState(() => isLogin = false)),
        ],
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
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: selected ? kPrimaryDarkColor : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameField() => _textField(_usernameController, "Username", false);
  Widget _emailField() => _textField(_emailController, "Email Address", false);

  Widget _passwordField() => _passwordInput(
        controller: _passwordController,
        hint: "Enter your password",
        obscureText: _obscurePassword,
        toggle: () => setState(() => _obscurePassword = !_obscurePassword),
      );

  Widget _confirmPasswordField() => _passwordInput(
        controller: _confirmPasswordController,
        hint: "Confirm your password",
        obscureText: _obscureConfirmPassword,
        toggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword),
      );

  Widget _roleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _roleOption("Student"),
        const SizedBox(width: 10),
        _roleOption("Vendor"),
      ],
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
        child: Text(
          role,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? kPrimaryDarkColor : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String hint, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordInput({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[700],
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}
