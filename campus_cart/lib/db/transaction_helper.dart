import 'package:sqflite/sqflite.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../db/database_helper.dart';

/// Helper class for handling multi-step order transactions
class TransactionHelper {
  final dbHelper = DatabaseHelper();

  /// Places a complete order, including inserting order and order items, and deducting stock
  ///
  /// Parameters:
  /// - order: Order object containing student name, status, etc.
  /// - items: List of OrderItem objects (itemId & quantity required)
  ///
  /// Returns:
  /// - true if successful, false otherwise
  Future<bool> placeOrder(Order order, List<OrderItem> items) async {
    final db = await dbHelper.database;

    try {
      // Start a database transaction
      await db.transaction((txn) async {
        // Insert the order into 'orders' table
        int orderId = await txn.insert('orders', order.toMap());

        // Iterate through each item in the order
        for (OrderItem item in items) {
          // Insert each order item (linking to the new order ID)
          await txn.insert('order_items', {
            'order_id': orderId,
            'item_id': item.itemId,
            'quantity': item.quantity,
          });

          // Get current stock of the item
          List<Map<String, dynamic>> itemResult = await txn.query(
            'menu_items',
            where: 'id = ?',
            whereArgs: [item.itemId],
          );

          if (itemResult.isNotEmpty) {
            int currentStock = itemResult.first['stock'];

            // Check if enough stock is available
            if (currentStock < item.quantity) {
              throw Exception("Not enough stock for item ID ${item.itemId}");
            }

            // Deduct stock
            int newStock = currentStock - item.quantity;

            // Update the item's stock
            await txn.update(
              'menu_items',
              {'stock': newStock},
              where: 'id = ?',
              whereArgs: [item.itemId],
            );
          } else {
            throw Exception("Menu item with ID ${item.itemId} not found");
          }
        }
      });

      // If we get here, everything succeeded
      return true;
    } catch (e) {
      // If any error occurs, the transaction will be rolled back automatically
      print("Transaction failed: $e");
      return false;
    }
  }
}
