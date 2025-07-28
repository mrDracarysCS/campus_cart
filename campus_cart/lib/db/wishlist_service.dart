import 'supabase_service.dart';

class WishlistService {
  static Future<List<Map<String, dynamic>>> getWishlist(String userId) async {
    final res = await SupabaseService.client
        .from('wishlist')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> addToWishlist(String userId, int menuItemId) async {
    await SupabaseService.client.from('wishlist').insert({
      'user_id': userId,
      'menu_item_id': menuItemId,
    });
  }

  static Future<void> removeFromWishlist(String userId, int menuItemId) async {
    await SupabaseService.client
        .from('wishlist')
        .delete()
        .eq('user_id', userId)
        .eq('menu_item_id', menuItemId);
  }
}
