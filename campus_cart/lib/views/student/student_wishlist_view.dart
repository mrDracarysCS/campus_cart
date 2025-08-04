import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/db/cart_service.dart';
import 'package:campus_cart/db/wishlist_service.dart';
import 'package:campus_cart/models/app_user.dart';

class WishlistView extends StatefulWidget {
  final AppUser user;

  const WishlistView({super.key, required this.user});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  List<Map<String, dynamic>> wishlistItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    setState(() => loading = true);
    final response = await WishlistService.getWishlist(widget.user.id);
    setState(() {
      wishlistItems = response;
      loading = false;
    });
  }

  Future<void> _removeFromWishlist(int productId) async {
    await WishlistService.removeFromWishlist(widget.user.id, productId);
    await _fetchWishlist();
  }

  Future<void> _moveToCart(Map<String, dynamic> item) async {
    // ✅ Use the mapped keys instead of `item['products']`
    final productId = item['productId'];
    if (productId == null) return;

    await CartService.addToCart(widget.user.id, productId, 1);
    await WishlistService.removeFromWishlist(widget.user.id, productId);
    await _fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: widget.user),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : wishlistItems.isEmpty
                    ? const Center(
                        child: Text(
                          "Your wishlist is empty.",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: wishlistItems.length,
                        itemBuilder: (context, index) {
                          final item = wishlistItems[index];

                          // ✅ Map the flattened structure
                          final product = {
                            'id': item['productId'],
                            'name': item['productName'],
                            'price': item['price'],
                            'image_url': item['imageUrl'],
                          };

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: Image.network(
                                product['image_url'] ?? '',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text(product['name'] ?? "Unnamed Product"),
                              subtitle: Text(
                                "\$${(product['price'] ?? 0).toStringAsFixed(2)}",
                              ),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _moveToCart(item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryLightColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Add to Cart"),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _removeFromWishlist(item['productId']),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}
