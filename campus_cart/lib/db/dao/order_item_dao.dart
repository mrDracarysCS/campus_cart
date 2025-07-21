import 'package:sqflite/sqflite.dart';
import '../../models/order_item.dart';
import '../database_helper.dart';

/// DAO for managing CRUD operations on the 'order_items' table
class OrderItemDao {
  final dbHelper = DatabaseHelper();

  /// Inserts a new item into an order
  Future<int> insertOrderItem(OrderItem item) async {
    final db = await dbHelper.database;
    return await db.insert('order_items', item.toMap());
  }

  /// Fetches all items belonging to a specific order
  Future<List<OrderItem>> getItemsByOrderId(int orderId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
    return result.map((map) => OrderItem.fromMap(map)).toList();
  }

  /// Deletes all items for a given order (e.g., when canceling an order)
  Future<int> deleteItemsByOrderId(int orderId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }
}
