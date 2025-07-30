import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/views/home_view.dart';
import 'package:campus_cart/views/search_view.dart';
import 'package:campus_cart/views/auth/login_register_view.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/views/student/student_account_view.dart';
import 'package:campus_cart/views/vendor/vendor_dashboard_view.dart';
import 'package:campus_cart/db/auth_service.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _handleAccountNavigation(BuildContext context) async {
    final user = await AuthService.getCurrentUser();

    if (user == null) {
      // ✅ Guest → Go to Login/Register
      _navigateTo(context, const LoginRegisterView(startInLogin: true));
    } else if (user.role == UserRole.student) {
      // ✅ Logged in student → Student Account View
      _navigateTo(context, StudentAccountView(user: user));
    } else if (user.role == UserRole.vendor) {
      // ✅ Logged in vendor → Vendor Dashboard
      _navigateTo(context, VendorDashboardView(user: user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDarkColor,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 100),

              // ✅ Logo + Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart,
                          size: 32, color: kAccentLightColor),
                      const SizedBox(width: 8),
                      Text(
                        "CampusCart",
                        style: GoogleFonts.patuaOne(
                          fontSize: 24,
                          color: kAccentLightColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your one-stop campus marketplace.",
                    style: TextStyle(fontSize: 14, color: kAccentLightColor),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Buy, sell, and connect with your college community!",
                    style: TextStyle(fontSize: 14, color: kAccentLightColor),
                  ),
                ],
              ),

              // ✅ Quick Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Links",
                    style: GoogleFonts.patuaOne(
                      fontSize: 18,
                      color: kAccentLightColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () => _navigateTo(context, const HomeView()),
                    child: const Text("Home",
                        style: TextStyle(
                            color: kAccentLightColor, fontSize: 14)),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () => _navigateTo(
                        context, const SearchView(user: AppUser.guest)),
                    child: const Text("Browse",
                        style: TextStyle(
                            color: kAccentLightColor, fontSize: 14)),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () => _handleAccountNavigation(context),
                    child: const Text("My Account",
                        style: TextStyle(
                            color: kAccentLightColor, fontSize: 14)),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () => _navigateTo(
                        context, const LoginRegisterView(startInLogin: true)),
                    child: const Text("Contact",
                        style: TextStyle(
                            color: kAccentLightColor, fontSize: 14)),
                  ),
                ],
              ),

              const SizedBox(width: 100),
            ],
          ),

          const SizedBox(height: 32),
          Divider(color: Colors.grey[600]),
          const SizedBox(height: 12),
          Text(
            "© ${DateTime.now().year} CampusCart. All rights reserved.",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
