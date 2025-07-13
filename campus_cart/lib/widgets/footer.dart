import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDarkColor,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: kAccentLightColor, size: 28),
              const SizedBox(width: 8),
              Text(
                'Campus Cart',
                style: GoogleFonts.patuaOne(
                  color: kAccentLightColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your campus marketplace to buy & sell products with ease.',
            style: TextStyle(color: kAccentLightColor, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: [
              _footerLink('Home'),
              _footerLink('Search'),
              _footerLink('Categories'),
              _footerLink('Contact'),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: kAccentLightColor.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            '© 2025 Campus Cart. All rights reserved.',
            style: TextStyle(color: kAccentLightColor.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: kAccentLightColor),
      ),
    );
  }
}
