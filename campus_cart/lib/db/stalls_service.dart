import '../models/stall.dart';
import '../models/product.dart';
import 'supabase_service.dart';

class StallsService {
  static Future<List<Stall>> getStalls() async {
    final res = await SupabaseService.client.from('stalls').select();
    return res.map<Stall>((e) => Stall.fromMap(e)).toList();
  }

  static Future<List<Product>> getProducts(int stallId) async {
    final res = await SupabaseService.client
        .from('menu_items')
        .select()
        .eq('stall_id', stallId);
    return res.map<Product>((e) => Product.fromMap(e)).toList();
  }

  static Future<void> addProduct(
    int stallId,
    String name,
    String description,
    double price,
    int stock,
    bool shippable, {
    String? imageUrl,
  }) async {
    await SupabaseService.client.from('menu_items').insert({
      'stall_id': stallId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'shippable': shippable,
      'image_url': imageUrl,
    });
  }
}
