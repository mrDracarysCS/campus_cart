import 'package:flutter/material.dart';
import 'package:campus_cart/models/user.dart';
import 'package:campus_cart/utils/constants.dart';

class LoginRegisterView extends StatefulWidget {
  const LoginRegisterView({super.key});

  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {
  bool isRegistering = false;
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  UserRole selectedRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(isRegistering ? 'Register' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (isRegistering)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                  validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              if (isRegistering)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text('Select Role'),
                    ListTile(
                      title: const Text('Student'),
                      leading: Radio<UserRole>(
                        value: UserRole.student,
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Vendor'),
                      leading: Radio<UserRole>(
                        value: UserRole.vendor,
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isRegistering) {
                      // TODO: Save new user to DB
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registered successfully!')),
                      );

                      if (selectedRole == UserRole.student) {
                        Navigator.pushNamedAndRemoveUntil(context, '/student', (route) => false);
                      } else if (selectedRole == UserRole.vendor) {
                        Navigator.pushNamedAndRemoveUntil(context, '/vendor', (route) => false);
                      }
                    } else {
                      // TODO: Authenticate user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged in!')),
                      );

                      if (selectedRole == UserRole.student) {
                        Navigator.pushNamedAndRemoveUntil(context, '/student', (route) => false);
                      } else if (selectedRole == UserRole.vendor) {
                        Navigator.pushNamedAndRemoveUntil(context, '/vendor', (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentLightColor,
                  foregroundColor: kPrimaryDarkColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isRegistering ? 'Register' : 'Login'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegistering = !isRegistering;
                  });
                },
                child: Text(isRegistering
                    ? 'Already have an account? Login'
                    : 'Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
