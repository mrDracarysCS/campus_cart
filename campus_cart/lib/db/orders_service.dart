import 'supabase_service.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrdersService {
  static Future<Order> placeOrder(
    String userId,
    int stallId,
    List<OrderItem> items,
  ) async {
    final orderResponse = await SupabaseService.client
        .from('orders')
        .insert({'user_id': userId, 'stall_id': stallId, 'status': 'pending'})
        .select()
        .single();

    final order = Order.fromMap(orderResponse);

    for (var item in items) {
      await SupabaseService.client.from('order_items').insert(item.toMap());
    }

    return order;
  }

  static Future<List<Order>> getOrders(String userId) async {
    final response = await SupabaseService.client
        .from('orders')
        .select()
        .eq('user_id', userId);

    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  static Future<List<OrderItem>> getOrderItems(int orderId) async {
    final response = await SupabaseService.client
        .from('order_items')
        .select()
        .eq('order_id', orderId);

    return response.map<OrderItem>((row) => OrderItem.fromMap(row)).toList();
  }
}
