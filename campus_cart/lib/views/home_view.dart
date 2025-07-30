import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/auth_service.dart';
import 'package:campus_cart/views/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AppUser currentUser = AppUser.guest;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user ?? AppUser.guest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopWebNavBar(user: currentUser),

            // ✅ HERO SECTION
            Stack(
              children: [
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/hero_banner.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 500,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.6),
                ),
                Center(
                  child: SizedBox(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentUser.role == UserRole.guest
                              ? 'Welcome to CampusCart'
                              : 'Welcome to CampusCart, ${currentUser.name}!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.patuaOne(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a1, a2) =>
                                    SearchView(user: currentUser),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentLightColor,
                            foregroundColor: kPrimaryDarkColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 18,
                            ),
                          ),
                          child: const Text(
                            'Explore Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryDarkColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ✅ FOOTER
            const Footer(),
          ],
        ),
      ),
    );
  }
}
