import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> categories = [];
  List<dynamic> featuredProducts = [];
  AppUser currentUser = AppUser.guest; // ✅ Store current user

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchFeaturedProducts();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user ?? AppUser.guest;
    });
  }

  Future<void> fetchCategories() async {
    final response = await Supabase.instance.client.from('categories').select();
    if (response is List) {
      setState(() => categories = response);
    }
  }

  Future<void> fetchFeaturedProducts() async {
    final response = await Supabase.instance.client
        .from('menu_items')
        .select()
        .limit(5);

    if (response is List) {
      setState(() => featuredProducts = response);
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
                          'Welcome to CampusCart',
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
                            Navigator.pushNamed(context, '/search');
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Browse Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: categories.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return _categoryCard(
                                cat['image_url'] ??
                                    'https://via.placeholder.com/150',
                                cat['name'] ?? 'No Name',
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 340,
                    child: featuredProducts.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredProducts.length,
                            itemBuilder: (context, index) {
                              final p = featuredProducts[index];
                              return _productCard(
                                p['image_url'] ??
                                    'https://via.placeholder.com/150',
                                p['name'] ?? 'No Name',
                                "${p['price'] ?? 0} ₹",
                                p['category'] ?? 'Uncategorized',
                                p['available'] == true,
                              );
                            },
                          ),
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

  static Widget _categoryCard(String imagePath, String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 120,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 120, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Explore amazing products',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  static Widget _productCard(
    String imagePath,
    String title,
    String price,
    String category,
    bool available,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
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
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 120, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(price,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(
            category,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            available ? 'Available' : 'Not Available',
            style: TextStyle(
              fontSize: 12,
              color: available ? Colors.green : Colors.red,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
