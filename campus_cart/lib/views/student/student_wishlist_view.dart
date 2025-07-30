import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  List<dynamic> wishlistItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('wishlist_items')
        .select('id, menu_items(id, name, price, image_url)')
        .eq('student_id', user.id);

    if (response is List) {
      setState(() {
        wishlistItems = response;
        loading = false;
      });
    }
  }

  Future<void> removeFromWishlist(int wishlistId) async {
    await Supabase.instance.client
        .from('wishlist_items')
        .delete()
        .eq('id', wishlistId);
    fetchWishlist();
  }

  Future<void> moveToCart(int menuItemId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Add to cart with quantity 1
    await Supabase.instance.client.from('cart_items').insert({
      'student_id': user.id,
      'menu_item_id': menuItemId,
      'quantity': 1
    });

    // Remove from wishlist
    await Supabase.instance.client
        .from('wishlist_items')
        .delete()
        .eq('menu_item_id', menuItemId)
        .eq('student_id', user.id);

    fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: kPrimaryDarkColor,
      ),
      backgroundColor: kBackgroundColor,
      body: loading
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
                    final product = item['menu_items'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Image.network(
                          product['image_url'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product['name']),
                        subtitle: Text("\$${product['price']}"),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  moveToCart(product['id'] as int),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryLightColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add to Cart"),
                            ),
                            IconButton(
                              onPressed: () =>
                                  removeFromWishlist(item['id'] as int),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
