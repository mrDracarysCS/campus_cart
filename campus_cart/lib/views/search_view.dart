import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/cart_service.dart';
import 'package:campus_cart/db/wishlist_service.dart';

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
  Set<int> wishlist = {}; // ✅ Track which products are in wishlist

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadWishlist(); // ✅ Load wishlist state
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

  Future<void> _loadWishlist() async {
    if (widget.user.role == UserRole.guest) return;

    final res = await Supabase.instance.client
        .from('wishlist_items')
        .select('menu_item_id')
        .eq('user_id', widget.user.id);

    if (res is List) {
      setState(() {
        wishlist = res.map<int>((item) => item['menu_item_id'] as int).toSet();
      });
    }
  }

  void filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        return name.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: widget.user),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 600 ? 12 : 24,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // 🔍 Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search products...",
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

                  // 📦 Responsive Products Grid
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const Center(child: Text("No products found"))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  screenWidth < 500 ? 200 : 280, // Auto fit
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                                  screenWidth < 500 ? 0.7 : 0.8, // Adjust ratio
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final p = filteredProducts[index];
                              return _productCard(context, p);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context, dynamic product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final productId = product['id'] as int;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['image_url'] ?? 'https://via.placeholder.com/150',
                height: screenWidth < 500 ? 100 : 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(height: 100, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['name'] ?? 'No Name',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "\$${(product['price'] ?? 0).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            const Spacer(),

            // 🛒 Add to Cart Button
            ElevatedButton.icon(
              onPressed: () async {
                if (widget.user.role == UserRole.guest) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠️ Please login to add to cart"),
                    ),
                  );
                  return;
                }

                await CartService.addToCart(widget.user.id, product['id'], 1);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Added to cart")),
                );
              },
              icon: const Icon(Icons.add_shopping_cart,
                  size: 16, color: Colors.white),
              label: const Text(
                "Add to Cart",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 98, 99, 99),
                minimumSize: const Size.fromHeight(36),
              ),
            ),

            const SizedBox(height: 6),

            // ❤️ Add/Remove Wishlist Button
            ElevatedButton.icon(
              onPressed: () async {
                if (widget.user.role == UserRole.guest) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠️ Please login to use wishlist"),
                    ),
                  );
                  return;
                }

                // ✅ Update UI first
                setState(() {
                  if (wishlist.contains(productId)) {
                    wishlist.remove(productId);
                  } else {
                    wishlist.add(productId);
                  }
                });

                // ✅ Then update Supabase
                if (wishlist.contains(productId)) {
                  await WishlistService.addToWishlist(widget.user.id, productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❤️ Added to wishlist")),
                  );
                } else {
                  await WishlistService.removeFromWishlist(widget.user.id, productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ Removed from wishlist")),
                  );
                }
              },
              icon: Icon(
                wishlist.contains(productId) ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              label: Text(
                wishlist.contains(productId) ? "Remove Wishlist" : "Add Wishlist",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    wishlist.contains(productId) ? Colors.redAccent : kAccentLightColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
