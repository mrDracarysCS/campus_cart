import 'supabase_service.dart';

class CartService {
  static Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final res = await SupabaseService.client
        .from('cart_items')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> addToCart(
    String userId,
    int menuItemId,
    int quantity,
  ) async {
    await SupabaseService.client.from('cart_items').insert({
      'user_id': userId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
    });
  }

  static Future<void> updateCartQuantity(
    String userId,
    int menuItemId,
    int quantity,
  ) async {
    await SupabaseService.client
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('user_id', userId)
        .eq('menu_item_id', menuItemId);
  }

  static Future<void> removeFromCart(String userId, int menuItemId) async {
    await SupabaseService.client
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('menu_item_id', menuItemId);
  }
}
