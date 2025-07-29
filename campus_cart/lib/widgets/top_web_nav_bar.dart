import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/views/home_view.dart';
import 'package:campus_cart/views/search_view.dart';
import 'package:campus_cart/views/student/cart_view.dart';
import 'package:campus_cart/views/student/student_wishlist_view.dart';
import 'package:campus_cart/views/auth/login_register_view.dart';

class TopWebNavBar extends StatelessWidget {
  final AppUser user;

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
          // ✅ Clickable Logo (Navigates to Home)
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const HomeView(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Row(
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
          ),

          Row(
            children: [
              _navButton(context, 'Home', const HomeView()),
              _navButton(context, 'Search', const SearchView()),
              _wishlistButton(context),
              _cartButton(context),
              const SizedBox(width: 12),

              if (isLoggedIn)
                _userAccountMenu(context)
              else
                Row(
                  children: [
                    _registerButton(context),
                    const SizedBox(width: 8),
                    _loginButton(context),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Generic Navigation Button
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
          style: const TextStyle(
            color: kAccentLightColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ✅ Wishlist Button
  Widget _wishlistButton(BuildContext context) {
    return _popupButton(
      context,
      label: 'Wishlist',
      view: const WishlistView(),
      popupMessage: 'Please login or register to access your wishlist.',
    );
  }

  // ✅ Cart Button
  Widget _cartButton(BuildContext context) {
    return _popupButton(
      context,
      label: 'Cart',
      view: const CartView(),
      popupMessage: 'Please login or register to access your cart.',
    );
  }

  // ✅ Reusable Pop-up Button
  Widget _popupButton(
    BuildContext context, {
    required String label,
    required Widget view,
    required String popupMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          if (user.role == UserRole.guest) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Login Required',
                  style: GoogleFonts.patuaOne(
                    fontSize: 20,
                    color: kPrimaryDarkColor,
                  ),
                ),
                content: Text(
                  popupMessage,
                  style: const TextStyle(
                    fontSize: 15,
                    color: kPrimaryDarkColor,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentLightColor,
                      foregroundColor: kPrimaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      foregroundColor: kPrimaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) =>
                              const LoginRegisterView(startInLogin: true),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: const Text('Login/Register'),
                  ),
                ],
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => view,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        child: Text(
          label,
          style: const TextStyle(
            color: kAccentLightColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ✅ Register Button
  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, a1, a2) =>
                const LoginRegisterView(startInLogin: false),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccentLightColor,
        foregroundColor: kPrimaryDarkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text('Register'),
    );
  }

  // ✅ Login Button
  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, a1, a2) =>
                const LoginRegisterView(startInLogin: true),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: kPrimaryDarkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text('Login'),
    );
  }

  // ✅ User Account Menu
  Widget _userAccountMenu(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.account_circle_rounded, color: kAccentLightColor),
        const SizedBox(width: 6),
        Text(
          user.name,
          style: const TextStyle(
            color: kAccentLightColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
