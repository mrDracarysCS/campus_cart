import 'supabase_service.dart';
import '../models/cart_item.dart';

class CartService {
  /// ✅ Add item to cart (updates quantity if already exists)
  static Future<bool> addToCart(
    String userId,
    int productId,
    int quantity,
  ) async {
    try {
      final existing = await SupabaseService.client
          .from('cart_items')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        final updatedQuantity = (existing['quantity'] ?? 0) + quantity;
        await SupabaseService.client
            .from('cart_items')
            .update({'quantity': updatedQuantity})
            .eq('id', existing['id']);
      } else {
        await SupabaseService.client.from('cart_items').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
      }
      return true;
    } catch (e) {
      print("❌ Error adding to cart: $e");
      return false;
    }
  }

  /// ✅ Remove item completely
  static Future<bool> removeFromCart(String userId, int productId) async {
    try {
      await SupabaseService.client
          .from('cart_items')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
      return true;
    } catch (e) {
      print("❌ Error removing from cart: $e");
      return false;
    }
  }

  static Future<List<CartItem>> getCart(String userId) async {
    try {
      final res = await SupabaseService.client
          .from('cart_items')
          .select('''
          id,
          user_id,
          product_id,
          quantity,
          products (
            id,
            name,
            price,
            image_url,
            stall_id,
            stalls (
              name
            )
          )
        ''')
          .eq('user_id', userId);

      return res.map<CartItem>((e) => CartItem.fromSupabase(e)).toList();
    } catch (e) {
      print("❌ Error fetching cart: $e");
      return [];
    }
  }

  /// ✅ Clear cart
  static Future<bool> clearCart(String userId) async {
    try {
      await SupabaseService.client
          .from('cart_items')
          .delete()
          .eq('user_id', userId);
      return true;
    } catch (e) {
      print("❌ Error clearing cart: $e");
      return false;
    }
  }
}
