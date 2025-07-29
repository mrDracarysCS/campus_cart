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
}
