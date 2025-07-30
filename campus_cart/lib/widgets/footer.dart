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
      _navigateTo(context, const LoginRegisterView(startInLogin: true));
    } else if (user.role == UserRole.student) {
      _navigateTo(context, StudentAccountView(user: user));
    } else if (user.role == UserRole.vendor) {
      _navigateTo(context, VendorDashboardView(user: user));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: kPrimaryDarkColor,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 40,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.stretch,
        children: [
          isMobile
              ? Column(
                  children: [
                    _logoSection(),
                    const SizedBox(height: 24),
                    _quickLinks(context),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 100),
                    _logoSection(),
                    _quickLinks(context),
                    const SizedBox(width: 100),
                  ],
                ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey[600]),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "© ${DateTime.now().year} CampusCart. All rights reserved.",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, size: 32, color: kAccentLightColor),
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
    );
  }

  Widget _quickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Links",
          style: GoogleFonts.patuaOne(fontSize: 18, color: kAccentLightColor),
        ),
        const SizedBox(height: 12),
        _link(context, "Home", const HomeView()),
        _link(context, "Browse", const SearchView(user: AppUser.guest)),
        GestureDetector(
          onTap: () => _handleAccountNavigation(context),
          child: const Text(
            "My Account",
            style: TextStyle(color: kAccentLightColor, fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        _link(context, "Contact", const LoginRegisterView(startInLogin: true)),
      ],
    );
  }

  Widget _link(BuildContext context, String label, Widget page) {
    return GestureDetector(
      onTap: () => _navigateTo(context, page),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          style: const TextStyle(color: kAccentLightColor, fontSize: 14),
        ),
      ),
    );
  }
}
