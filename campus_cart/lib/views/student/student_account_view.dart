import 'package:flutter/material.dart';
import 'package:campus_cart/models/user.dart';
import 'package:campus_cart/utils/constants.dart';

class StudentAccountView extends StatelessWidget {
  final User user;

  const StudentAccountView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: kPrimaryDarkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryDarkColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${user.role.toString().split('.').last}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Add edit profile logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentLightColor,
                foregroundColor: kPrimaryDarkColor,
              ),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // TODO: View order history
              },
              child: const Text('View Orders'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // TODO: View wishlist
              },
              child: const Text('View Wishlist'),
            ),
          ],
        ),
      ),
    );
  }
}
