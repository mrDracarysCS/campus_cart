import 'package:flutter/material.dart';
import 'package:campus_cart/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class TopWebNavBarStudent extends StatelessWidget {
  final User user;

  const TopWebNavBarStudent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      color: kPrimaryDarkColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with icon
          Row(
            children: [
              Icon(Icons.shopping_cart, color: kAccentLightColor, size: 32),
              const SizedBox(width: 8),
              Text(
                'Campus Cart',
                style: GoogleFonts.patuaOne(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: kAccentLightColor,
                ),
              ),
            ],
          ),

          Row(
            children: [
              _navButton('Home'),
              _navButton('Search'),
              _navButton('Wishlist'),
              _navButton('Cart'),
              const SizedBox(width: 12),
              _userAccountMenu(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: const TextStyle(color: kAccentLightColor),
        ),
      ),
    );
  }

  Widget _userAccountMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account Menu',
      onSelected: (value) {
        if (value == 'logout') {
          // TODO: handle logout logic
        } else if (value == 'account') {
          // TODO: navigate to student account
        } else if (value == 'orders') {
          // TODO: navigate to orders
        } else if (value == 'wishlist') {
          // TODO: navigate to wishlist
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(value: 'account', child: Text('My Account')),
          const PopupMenuItem(value: 'orders', child: Text('My Orders')),
          const PopupMenuItem(value: 'wishlist', child: Text('Wishlist')),
          const PopupMenuItem(value: 'logout', child: Text('Log Out')),
        ];
      },
      child: Row(
        children: [
          Icon(Icons.account_circle_rounded, color: kAccentLightColor),
          const SizedBox(width: 6),
          Text(
            user.name,
            style: const TextStyle(
              color: kAccentLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: kAccentLightColor),
        ],
      ),
    );
  }
}
