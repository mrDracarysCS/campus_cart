import 'package:flutter/material.dart';
import 'package:campus_cart/models/user.dart';

class TopWebNavBar extends StatelessWidget {
  final User user;

  const TopWebNavBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = user.role != UserRole.guest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Campus', style: TextStyle(color: Colors.blue)),
                TextSpan(text: 'Cart', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),

          // Navigation menu
          Row(
            children: [
              _navButton('Home'),
              _navButton('Search'),
              _navButton('Wishlist', showBadge: true, badgeCount: 0),
              _navButton('Cart', showBadge: true, badgeCount: 0),
              const SizedBox(width: 12),

              // Right-side buttons: account or login/register
              if (isLoggedIn)
                _userAccountMenu(context)
              else
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to register page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Register'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to login page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navButton(String label, {bool showBadge = false, int badgeCount = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextButton(
            onPressed: () {
              // TODO: handle nav
            },
            child: Text(
              label,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _userAccountMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account Menu',
      onSelected: (value) {
        // TODO: Handle account actions
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(value: 'account', child: Text('My Account')),
          const PopupMenuItem(value: 'logout', child: Text('Log Out')),
        ];
      },
      child: Row(
        children: [
          const Icon(Icons.account_circle_rounded, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
