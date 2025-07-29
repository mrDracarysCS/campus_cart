import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

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
    final response = await Supabase.instance.client.from('products').select();

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
        final category = (product['category'] ?? '').toString().toLowerCase();

        final matchesSearch = name.contains(searchQuery.toLowerCase());
        final matchesCategory = selectedCategory.isEmpty ||
            category == selectedCategory.toLowerCase();

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          const TopWebNavBar(user: AppUser.guest),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Sidebar Categories (Scrollable)
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
                                  selectedCategory = selectedCategory == category
                                      ? ''
                                      : category;
                                });
                                filterProducts();
                              },
                              child: Text(category,
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 📌 Main Product Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 🔍 Search Bar
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
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  searchQuery = value;
                                  filterProducts();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: filterProducts,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccentLightColor,
                                foregroundColor: kPrimaryDarkColor,
                              ),
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 📦 Product Grid
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];

                              final name =
                                  (product['name'] ?? 'No Name').toString();
                              final price =
                                  (product['price']?.toString() ?? 'N/A');
                              final category =
                                  (product['category'] ?? 'Uncategorized')
                                      .toString();
                              final shippingAvailable =
                                  (product['shipping'] ?? false) == true;
                              final imageUrl = product['image_url'] ??
                                  'https://via.placeholder.com/150';

                              return _buildProductCard(
                                name,
                                price,
                                category,
                                shippingAvailable,
                                imageUrl,
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

  Widget _buildProductCard(
    String name,
    String price,
    String category,
    bool shippingAvailable,
    String imageUrl,
  ) {
    return Container(
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
          // 🖼 Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 120, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 8),

          // 📄 Product Title
          Text(
            name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // 💲 Price
          Text("$price ₹",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

          // 🏷 Category
          Text(category,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),

          // 🚚 Shipping
          Text(
            shippingAvailable ? "Available" : "Not Available",
            style: TextStyle(
              fontSize: 12,
              color: shippingAvailable ? Colors.green : Colors.red,
            ),
          ),

          const Spacer(),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("View Details"),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryLightColor,
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
