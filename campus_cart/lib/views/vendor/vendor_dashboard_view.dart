import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class VendorDashboardView extends StatelessWidget {
  const VendorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(
          'Vendor Dashboard',
          style: GoogleFonts.patuaOne(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement logout logic
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Vendor!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryDarkColor,
              ),
            ),
            const SizedBox(height: 20),
            _dashboardButton(context, 'Add New Product', Icons.add_box, () {
              Navigator.pushNamed(context, '/vendor/add-product');
            }),
            _dashboardButton(context, 'View My Products', Icons.list_alt, () {
              Navigator.pushNamed(context, '/vendor/products');
            }),
            _dashboardButton(context, 'View Orders', Icons.receipt_long, () {
              Navigator.pushNamed(context, '/vendor/orders');
            }),
          ],
        ),
      ),
    );
  }

  Widget _dashboardButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentLightColor,
          foregroundColor: kPrimaryDarkColor,
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }
}
