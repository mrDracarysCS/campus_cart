import 'supabase_service.dart';
import '../models/cart_item.dart';

class CartService {
  static Future<void> addToCart(
    String userId,
    int productId,
    int quantity,
  ) async {
    await SupabaseService.client.from('cart_items').insert({
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    });
  }

  static Future<void> removeFromCart(String userId, int productId) async {
    await SupabaseService.client
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  static Future<List<CartItem>> getCart(String userId) async {
    final res = await SupabaseService.client
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    return res.map<CartItem>((e) => CartItem.fromMap(e)).toList();
  }
}
