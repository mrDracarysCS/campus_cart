import 'package:flutter/material.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/db/auth_service.dart';
import 'package:campus_cart/views/home_view.dart';

class VendorAccountView extends StatelessWidget {
  final AppUser user;

  const VendorAccountView({super.key, required this.user});

  void _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Vendor Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryDarkColor,
              ),
            ),
            const SizedBox(height: 16),
            Text("Name: ${user.name}", style: const TextStyle(fontSize: 16)),
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
