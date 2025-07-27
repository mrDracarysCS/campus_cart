import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/models/user.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          const TopWebNavBar(user: User.guest),
          Expanded(
            child: Center(
              child: Text(
                'Search Page',
                style: GoogleFonts.patuaOne(
                  fontSize: 32,
                  color: kPrimaryDarkColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
