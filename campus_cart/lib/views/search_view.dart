import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/cart_service.dart';
import 'package:campus_cart/views/auth/login_register_view.dart';

class SearchView extends StatefulWidget {
  final AppUser user;

  const SearchView({super.key, required this.user});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  String searchQuery = '';
  String selectedCategory = '';

  final List<String> categories = [
    "Meals",
    "Snacks",
    "Drinks",
    "Desserts",
    "Breakfast",
    "Healthy Options",
    "Special Offers",
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await Supabase.instance.client
        .from('products')
        .select('*, stalls(name)');

    if (response is List) {
      setState(() {
        products = response;
        filteredProducts = response;
      });
    }
  }

  void filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final matchesSearch = name.contains(searchQuery.toLowerCase());

        return matchesSearch;
      }).toList();
    });
  }

  Future<void> _addToCart(dynamic product) async {
    if (widget.user.role == UserRole.guest) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: kBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Login Required'),
          content: const Text(
            'Please login or register to add items to your cart.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginRegisterView(startInLogin: true),
                  ),
                );
              },
              child: const Text('Login/Register'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await CartService.addToCart(widget.user.id, product['id'], 1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Added to cart"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add to cart"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: widget.user),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar Filters
                Container(
                  width: 250,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filter by Category",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryDarkColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final category in categories)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedCategory == category
                                    ? kAccentLightColor
                                    : Colors.white,
                                foregroundColor: kPrimaryDarkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedCategory =
                                      selectedCategory == category
                                      ? ''
                                      : category;
                                });
                                filterProducts();
                              },
                              child: Text(
                                category,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Main Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search menu items",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                  filterProducts();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Expanded(
                          child: filteredProducts.isEmpty
                              ? const Center(child: Text("No products found"))
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.78,
                                      ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final p = filteredProducts[index];
                                    final stallName =
                                        p['stalls']?['name'] ?? 'Unknown Stall';

                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                            child: Image.network(
                                              p['image_url'] ??
                                                  'https://via.placeholder.com/150',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p['name'] ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "\$${p['price']?.toStringAsFixed(2) ?? '0.00'}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  stallName,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () =>
                                                        _addToCart(p),
                                                    icon: const Icon(
                                                      Icons.add_shopping_cart,
                                                      size: 16,
                                                    ),
                                                    label: const Text(
                                                      "Add to Cart",
                                                    ),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}
