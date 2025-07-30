import '../models/product.dart';
import 'supabase_service.dart';

class ProductService {
  /// ✅ Get all products
  static Future<List<Product>> getAllProducts() async {
    final res = await SupabaseService.client.from('products').select();
    return res.map<Product>((p) => Product.fromMap(p)).toList();
  }

  /// ✅ Search products by keyword
  static Future<List<Product>> searchProducts(String keyword) async {
    final res = await SupabaseService.client
        .from('products')
        .select()
        .ilike('name', '%$keyword%');
    return res.map<Product>((p) => Product.fromMap(p)).toList();
  }

  /// ✅ Get products for a stall
  static Future<List<Product>> getProductsByStall(int stallId) async {
    final res = await SupabaseService.client
        .from('products')
        .select()
        .eq('stall_id', stallId);
    return res.map<Product>((p) => Product.fromMap(p)).toList();
  }

  /// ✅ Get single product
  static Future<Product?> getProduct(int productId) async {
    final res = await SupabaseService.client
        .from('products')
        .select()
        .eq('id', productId)
        .maybeSingle();

    return res != null ? Product.fromMap(res) : null;
  }

  /// ✅ Add a product to a stall
  static Future<bool> addProduct({
    required int stallId,
    required String name,
    required String description,
    required double price,
    required int stock,
    bool shippable = false,
    String? imageUrl,
  }) async {
    try {
      await SupabaseService.client.from('products').insert({
        'stall_id': stallId,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'shippable': shippable,
        'image_url': imageUrl,
      });

      return true; // ✅ Success if no exception
    } catch (e) {
      print("❌ Error adding product: $e");
      return false;
    }
  }

  /// ✅ Delete product
  static Future<bool> deleteProduct(int productId) async {
    try {
      final res = await SupabaseService.client
          .from('products')
          .delete()
          .eq('id', productId);

      return res.error == null;
    } catch (e) {
      print("❌ Error deleting product: $e");
      return false;
    }
  }

  /// ✅ Update product
  static Future<bool> updateProduct({
    required int productId,
    String? name,
    String? description,
    double? price,
    int? stock,
    bool? shippable,
    String? imageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (price != null) updateData['price'] = price;
      if (stock != null) updateData['stock'] = stock;
      if (shippable != null) updateData['shippable'] = shippable;
      if (imageUrl != null) updateData['image_url'] = imageUrl;

      final res = await SupabaseService.client
          .from('products')
          .update(updateData)
          .eq('id', productId);

      return res.error == null;
    } catch (e) {
      print("❌ Error updating product: $e");
      return false;
    }
  }
}
