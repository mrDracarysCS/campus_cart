import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/auth_service.dart';
import 'package:campus_cart/views/student/student_orders_view.dart';
import 'package:campus_cart/views/student/student_wishlist_view.dart';
import 'package:campus_cart/views/auth/login_register_view.dart';

class StudentAccountView extends StatelessWidget {
  final AppUser user;

  const StudentAccountView({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginRegisterView(startInLogin: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: user), // ✅ Show top nav bar

          Expanded(
            child: Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'My Account',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome, ${user.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Role: ${user.role.toString().split('.').last}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentOrdersView(user: user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentLightColor,
                        foregroundColor: kPrimaryDarkColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      child: const Text("View Orders"),
                    ),
                    const SizedBox(height: 10),

                    /* ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentWishlistView(user: user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentLightColor,
                        foregroundColor: kPrimaryDarkColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                      ),
                      child: const Text("View Wishlist"),
                    ),
                    const SizedBox(height: 10),*/
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Footer(), // ✅ Show footer
        ],
      ),
    );
  }
}
