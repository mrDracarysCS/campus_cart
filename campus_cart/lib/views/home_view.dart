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
  List<dynamic> stalls = [];
  AppUser currentUser = AppUser.guest;

  @override
  void initState() {
    super.initState();
    fetchStalls();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user ?? AppUser.guest;
    });
  }

  Future<void> fetchStalls() async {
    final response = await Supabase.instance.client.from('stall').select();
    if (response is List) {
      setState(() => stalls = response);
    }
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
                                horizontal: 32, vertical: 18),
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

            // ✅ STALLS GRID SECTION
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Stalls',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  stalls.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: stalls.map((stall) {
                            return _stallCard(
                              stall['image_url'] ??
                                  'https://via.placeholder.com/200',
                              stall['name'] ?? 'No Name',
                              stall['description'] ?? 'No description available',
                              () {
                                // TODO: Navigate to Stall Details
                              },
                              () {
                                // ✅ Go to SearchView filtered for this stall
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SearchView(user: currentUser),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  // ✅ STALL CARD WIDGET
  Widget _stallCard(String image, String name, String description,
      VoidCallback onViewDetails, VoidCallback onExploreMenu) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 120, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onExploreMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Explore Menu'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
