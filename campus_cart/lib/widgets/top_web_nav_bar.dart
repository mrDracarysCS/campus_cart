import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/models/user.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/views/home_view.dart';
import 'package:campus_cart/views/search_view.dart';
import 'package:campus_cart/views/student/cart_view.dart';
import 'package:campus_cart/views/student/wishlist_view.dart';

class TopWebNavBar extends StatelessWidget {
  final User user;

  const TopWebNavBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = user.role != UserRole.guest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      color: kPrimaryDarkColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(Icons.shopping_cart, color: kAccentLightColor, size: 32),
              const SizedBox(width: 8),
              Text(
                'CampusCart',
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
              _navButton(context, 'Home', const HomeView()),
              _navButton(context, 'Search', const SearchView()),
              _wishlistButton(context),
              _navButton(context, 'Cart', const CartView()),
              const SizedBox(width: 12),
              if (isLoggedIn)
                _userAccountMenu(context)
              else
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentLightColor,
                        foregroundColor: kPrimaryDarkColor,
                      ),
                      child: const Text('Register'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryLightColor,
                        foregroundColor: kPrimaryDarkColor,
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

  Widget _navButton(BuildContext context, String label, Widget targetView) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => targetView,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: Text(
          label,
          style: const TextStyle(color: kAccentLightColor),
        ),
      ),
    );
  }

  Widget _wishlistButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          if (user.role == UserRole.guest) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: kPrimaryDarkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Login Required',
                  style: GoogleFonts.patuaOne(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: kAccentLightColor,
                  ),
                ),
                content: Text(
                  'Please login or register to access your wishlist.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: kAccentLightColor,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentLightColor,
                      foregroundColor: kPrimaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      foregroundColor: kPrimaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child:
                        Text('Login/Register', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const WishlistView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        child: const Text(
          'Wishlist',
          style: TextStyle(color: kAccentLightColor),
        ),
      ),
    );
  }

  Widget _userAccountMenu(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
