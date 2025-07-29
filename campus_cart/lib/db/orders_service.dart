import '../models/order.dart';
import '../models/order_list.dart';
import '../models/product.dart';
import 'supabase_service.dart';

class OrdersService {
  /// ✅ Place a new order with multiple products
  static Future<Order> placeOrder(
    String userId,
    int stallId,
    List<OrderList> products,
  ) async {
    // 1️⃣ Create a new order
    final orderRes = await SupabaseService.client
        .from('orders')
        .insert({'user_id': userId, 'stall_id': stallId, 'status': 'pending'})
        .select()
        .single();

    final order = Order.fromMap(orderRes);

    // 2️⃣ Insert all products in order_list
    for (var item in products) {
      await SupabaseService.client.from('order_list').insert(item.toMap());
    }

    return order;
  }

  /// ✅ Get all orders for a user
  static Future<List<Order>> getOrders(String userId) async {
    final res = await SupabaseService.client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return res.map<Order>((e) => Order.fromMap(e)).toList();
  }

  /// ✅ Get all products for a specific order (joined with product details)
  static Future<List<Map<String, dynamic>>> getOrderDetails(int orderId) async {
    final res = await SupabaseService.client
        .from('order_list')
        .select('quantity, products(name, price, description, shippable)')
        .eq('order_id', orderId);

    return List<Map<String, dynamic>>.from(res);
  }

  /// ✅ Get a full order object with products included
  static Future<Map<String, dynamic>> getFullOrder(int orderId) async {
    // 1️⃣ Get the order info
    final orderRes = await SupabaseService.client
        .from('orders')
        .select()
        .eq('id', orderId)
        .maybeSingle();

    if (orderRes == null) return {};

    final order = Order.fromMap(orderRes);

    // 2️⃣ Get all products for this order
    final itemsRes = await SupabaseService.client
        .from('order_list')
        .select('quantity, products(*)')
        .eq('order_id', orderId);

    final products = itemsRes
        .map(
          (row) => {
            'quantity': row['quantity'],
            'product': Product.fromMap(row['products']),
          },
        )
        .toList();

    return {
      'order': order,
      'items': products, // List of { quantity, product }
    };
  }

  /// ✅ Update order status (vendor only)
  static Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await SupabaseService.client
        .from('orders')
        .update({'status': newStatus})
        .eq('id', orderId);
  }
}
