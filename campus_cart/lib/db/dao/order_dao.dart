import 'package:sqflite/sqflite.dart';
import '../../models/order.dart';
import '../database_helper.dart';

/// DAO for managing CRUD operations on the 'orders' table
class OrderDao {
  final dbHelper = DatabaseHelper();

  /// Inserts a new order
  Future<int> insertOrder(Order order) async {
    final db = await dbHelper.database;
    return await db.insert('orders', order.toMap());
  }

  /// Fetches all orders with optional filtering by status
  Future<List<Order>> getOrders({String? status}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'orders',
      where: status != null ? 'status = ?' : null,
      whereArgs: status != null ? [status] : null,
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Order.fromMap(map)).toList();
  }

  /// Updates an order’s status
  Future<int> updateOrder(Order order) async {
    final db = await dbHelper.database;
    return await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  /// Deletes an order
  Future<int> deleteOrder(int id) async {
    final db = await dbHelper.database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
