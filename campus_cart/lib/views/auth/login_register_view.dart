import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRegisterView extends StatefulWidget {
  final bool startInLogin;

  const LoginRegisterView({super.key, this.startInLogin = true});

  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {
  late bool isLogin;
  String selectedRole = "Student";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    isLogin = widget.startInLogin;
  }

  Future<void> handleSubmit() async {
    if (!isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      _showMessage("Passwords do not match!", Colors.red);
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showMessage("Email and password are required!", Colors.red);
      return;
    }

    setState(() => loading = true);
    final supabase = Supabase.instance.client;

    try {
      if (isLogin) {
        // 🔹 LOGIN
        final response = await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user == null) {
          _showMessage("Login failed. Check email or password.", Colors.red);
          return;
        }

        final userData = await supabase
            .from('users')
            .select('role')
            .eq('id', response.user!.id)
            .maybeSingle();

        if (!mounted) return;

        if (userData == null) {
          _showMessage("No user profile found. Contact support.", Colors.red);
          return;
        }

        final role = userData['role'] as String;
        if (role == 'vendor') {
          Navigator.pushReplacementNamed(context, '/vendor');
        } else {
          Navigator.pushReplacementNamed(context, '/student');
        }
      } else {
        // 🔹 REGISTER
        final response = await supabase.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          await supabase.from('users').insert({
            'id': response.user!.id,
            'name': _usernameController.text.trim(),
            'email': _emailController.text.trim(),
            'role': selectedRole.toLowerCase(),
          });

          _showMessage("✅ Account created! Please log in.", Colors.green);
          setState(() => isLogin = true);
        } else {
          _showMessage("Registration failed. Try again.", Colors.red);
        }
      }
    } catch (e) {
      _showMessage("Error: $e", Colors.red);
    } finally {
      setState(() => loading = false);
    }
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
              _buildToggleButtons(),
              const SizedBox(height: 20),

              if (!isLogin) ...[
                _buildTextField(_usernameController, "Username", false),
                const SizedBox(height: 12),
                _buildRoleSelector(),
                const SizedBox(height: 12),
              ],

              _buildTextField(_emailController, "Email Address", false),
              const SizedBox(height: 12),
              _buildTextField(_passwordController, "Password", true),

              if (!isLogin) ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _confirmPasswordController,
                  "Confirm Password",
                  true,
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 80,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: kAccentLightColor,
                  foregroundColor: kPrimaryDarkColor,
                ),
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        isLogin ? "Login" : "Register",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              _buildSwitchAuthText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
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

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _toggleButton("Login", isLogin, () => setState(() => isLogin = true)),
          _toggleButton(
            "Signup",
            !isLogin,
            () => setState(() => isLogin = false),
          ),
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

  Widget _buildSwitchAuthText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isLogin ? "Not a member?" : "Already have an account?"),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => setState(() => isLogin = !isLogin),
          child: Text(
            isLogin ? "Signup now" : "Login here",
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
