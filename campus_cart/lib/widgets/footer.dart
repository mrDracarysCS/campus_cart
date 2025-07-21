import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDarkColor,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      child: Column(
        children: [
          // Main footer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column 1 (empty)
              const SizedBox(width: 100),

              // Column 2: Logo and description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  Text(
                    "Your one-stop campus marketplace.",
                    style: GoogleFonts.poppins(
                      color: kAccentLightColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Buy, sell, and connect with your college community!",
                    style: GoogleFonts.poppins(
                      color: kAccentLightColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Column 3: Quick Links
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
                  Text("Home", style: GoogleFonts.poppins(color: kAccentLightColor)),
                  const SizedBox(height: 8),
                  Text("Browse", style: GoogleFonts.poppins(color: kAccentLightColor)),
                  const SizedBox(height: 8),
                  Text("My Account", style: GoogleFonts.poppins(color: kAccentLightColor)),
                  const SizedBox(height: 8),
                  Text("Contact", style: GoogleFonts.poppins(color: kAccentLightColor)),
                ],
              ),

              // Column 4 (empty)
              const SizedBox(width: 100),
            ],
          ),

          const SizedBox(height: 32),

          // Copyright
          Divider(color: Colors.grey[600]),
          const SizedBox(height: 12),
          Text(
            "© ${DateTime.now().year} CampusCart. All rights reserved.",
            style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
