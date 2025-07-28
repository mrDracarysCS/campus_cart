import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/models/app_user.dart';

class TopWebNavBarStudent extends StatelessWidget {
  final AppUser user;

  const TopWebNavBarStudent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDarkColor,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section: Logo
          Row(
            children: [
              const Icon(Icons.shopping_cart, color: kAccentLightColor),
              const SizedBox(width: 8),
              Text(
                'Campus Cart',
                style: GoogleFonts.patuaOne(
                  fontSize: 20,
                  color: kAccentLightColor,
                ),
              ),
            ],
          ),

          // Middle section: Menu items
          Row(
            children: [
              _navItem(context, 'Home', '/studentHome'),
              const SizedBox(width: 24),
              _navItem(context, 'Search', '/search'),
              const SizedBox(width: 24),
              _navItem(context, 'Wishlist', '/wishlist'),
              const SizedBox(width: 24),
              _navItem(context, 'Cart', '/cart'),
            ],
          ),

          // Right section: Account menu
          Row(
            children: [
              Text(
                user.name,
                style: GoogleFonts.poppins(
                  color: kAccentLightColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.account_circle,
                  color: kAccentLightColor,
                ),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'account') {
                    Navigator.pushNamed(context, '/studentAccount');
                  } else if (value == 'logout') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'account',
                    child: Text('My Account'),
                  ),
                  const PopupMenuItem(value: 'logout', child: Text('Log Out')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, color: kAccentLightColor),
      ),
    );
  }
}
