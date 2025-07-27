import 'supabase_service.dart';

class AnalyticsService {
  static Future<int> getTotalOrdersToday() async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final result = await SupabaseService.client
        .from('orders')
        .select()
        .gte('created_at', '$today 00:00:00')
        .lte('created_at', '$today 23:59:59');

    return result.length;
  }

  static Future<List<Map<String, dynamic>>> getTopSellingItems() async {
    // Supabase supports SQL functions via RPC or using a View
    final query = '''
      SELECT mi.name, SUM(oi.quantity) AS total_sold
      FROM order_items oi
      JOIN menu_items mi ON oi.menu_item_id = mi.id
      GROUP BY mi.name
      ORDER BY total_sold DESC
      LIMIT 5
    ''';

    return await SupabaseService.client.rpc(
      'execute_sql',
      params: {'sql': query},
    );
  }
}
