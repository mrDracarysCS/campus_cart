import '../models/order.dart';
import '../models/order_list.dart';
import 'supabase_service.dart';

class OrdersService {
  /// ✅ Place a new order for a stall
  static Future<Order?> placeOrder(
    String userId,
    int stallId,
    List<OrderList> items,
  ) async {
    try {
      // 1️⃣ Insert order and get its ID
      final orderRes = await SupabaseService.client
          .from('orders')
          .insert({'user_id': userId, 'stall_id': stallId, 'status': 'pending'})
          .select()
          .single();

      final order = Order.fromMap(orderRes);
      final orderId = order.id;

      // 2️⃣ Insert items into order_list
      for (var item in items) {
        await SupabaseService.client.from('order_list').insert({
          'order_id': orderId,
          'product_id': item.productId,
          'quantity': item.quantity,
        });
      }

      return order; // ✅ Success
    } catch (e) {
      print("❌ Error placing order: $e");
      return null; // ❌ Failure
    }
  }

  /// ✅ Get orders for a user
  static Future<List<Order>> getOrders(String userId) async {
    final res = await SupabaseService.client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return res.map<Order>((e) => Order.fromMap(e)).toList();
  }

  /// ✅ Get items of an order
  static Future<List<OrderList>> getOrderItems(int orderId) async {
    final res = await SupabaseService.client
        .from('order_list')
        .select()
        .eq('order_id', orderId);

    return res.map<OrderList>((e) => OrderList.fromMap(e)).toList();
  }
}
