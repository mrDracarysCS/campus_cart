import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';

/// Helper class to run analytics queries for dashboards and reports
class AnalyticsHelper {
  final dbHelper = DatabaseHelper();

  /// Returns total number of orders placed today
  Future<int> getTotalOrdersToday() async {
    final db = await dbHelper.database;

    // Get today's date in 'YYYY-MM-DD' format
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];

    // Run SQL query to count orders from today
    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as total FROM orders
      WHERE DATE(created_at) = ?
    ''',
      [todayStr],
    );

    // Return the total as an integer
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Returns a list of menu item IDs and their total quantities ordered, sorted by popularity
  ///
  /// Optional: filter by a specific stall
  Future<List<Map<String, dynamic>>> getTopSellingItems({
    int? stallId,
    int limit = 5,
  }) async {
    final db = await dbHelper.database;

    // Build base query
    String query = '''
      SELECT mi.id, mi.name, SUM(oi.quantity) as total_sold
      FROM order_items oi
      JOIN menu_items mi ON oi.item_id = mi.id
    ''';

    // Add optional stall filter
    if (stallId != null) {
      query += ' WHERE mi.stall_id = $stallId';
    }

    query +=
        '''
      GROUP BY mi.id
      ORDER BY total_sold DESC
      LIMIT $limit
    ''';

    // Execute query and return result list
    final result = await db.rawQuery(query);
    return result;
  }

  /// Returns list of menu items with stock below the given threshold
  ///
  /// Optional: filter by stall
  Future<List<Map<String, dynamic>>> getLowStockItems({
    int threshold = 5,
    int? stallId,
  }) async {
    final db = await dbHelper.database;

    // Build base query
    String whereClause = 'stock < ?';
    List<dynamic> whereArgs = [threshold];

    if (stallId != null) {
      whereClause += ' AND stall_id = ?';
      whereArgs.add(stallId);
    }

    // Query menu_items table
    final result = await db.query(
      'menu_items',
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result;
  }
}
