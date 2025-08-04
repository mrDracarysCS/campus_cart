import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/db/wishlist_service.dart';
import 'supabase_service.dart';


class WishlistService {
  static final _client = Supabase.instance.client;

   // ✅ Fetch wishlist with product details
  static Future<List<Map<String, dynamic>>> getWishlist(String userId) async {
  try {
    final res = await SupabaseService.client
        .from('wishlist')
        .select('id, product_id, products(*)') // Join products table
        .eq('user_id', userId);

    print("Wishlist fetch result: $res"); // ✅ DEBUG

    return res.map<Map<String, dynamic>>((item) {
      final p = item['products'] ?? {};
      return {
        'id': item['id'],
        'productId': item['product_id'],
        'productName': p['name'] ?? '',
        'price': p['price'] ?? 0.0,
        'imageUrl': p['image_url'] ?? '',
      };
    }).toList();
  } catch (e) {
    print("❌ Error fetching wishlist: $e");
    return [];
  }
}



  static Future<void> removeFromWishlist(String userId, int productId) async {
    await _client
        .from('wishlist_items')
        .delete()
        .eq('student_id', userId)
        .eq('menu_item_id', productId);
  }

  static Future<void> removeByProduct(String userId, int productId) async {
    await _client
        .from('wishlist_items')
        .delete()
        .eq('user_id', userId)
        .eq('menu_item_id', productId);
  }

  static Future<bool> addToWishlist(String userId, int productId) async {
    try {
      // Check if already exists
      final existing = await SupabaseService.client
          .from('wishlist') // ✅ Correct table name
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        print("ℹ️ Item already in wishlist");
        return true;
      }

      // Insert new item
      await SupabaseService.client.from('wishlist').insert({
        'user_id': userId,
        'product_id': productId,
      });

      print("✅ Added to wishlist");
      return true;
    } catch (e) {
      print("❌ Error adding to wishlist: $e");
      return false;
    }
  }
}
