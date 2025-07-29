import '../models/order.dart';
import '../models/order_list.dart';
import 'supabase_service.dart';

class OrdersService {
  static Future<Order> placeOrder(
    String userId,
    int stallId,
    List<OrderList> items,
  ) async {
    final orderRes = await SupabaseService.client
        .from('orders')
        .insert({'user_id': userId, 'stall_id': stallId, 'status': 'pending'})
        .select()
        .single();

    final order = Order.fromMap(orderRes);

    for (var item in items) {
      await SupabaseService.client.from('order_list').insert(item.toMap());
    }

    return order;
  }

  static Future<List<Order>> getOrders(String userId) async {
    final res = await SupabaseService.client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return res.map<Order>((e) => Order.fromMap(e)).toList();
  }

  static Future<List<OrderList>> getOrderItems(int orderId) async {
    final res = await SupabaseService.client
        .from('order_list')
        .select()
        .eq('order_id', orderId);

    return res.map<OrderList>((e) => OrderList.fromMap(e)).toList();
  }
}
