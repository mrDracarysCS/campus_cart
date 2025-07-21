import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';

/// Helper class for managing manual stock adjustments
class StockHelper {
  final dbHelper = DatabaseHelper();

  /// Deducts stock for a specific menu item
  ///
  /// Parameters:
  /// - itemId: ID of the menu item
  /// - quantity: Quantity to deduct
  ///
  /// Returns:
  /// - true if successful, false otherwise
  Future<bool> deductStock(int itemId, int quantity) async {
    final db = await dbHelper.database;

    try {
      // Query current stock for the given item
      List<Map<String, dynamic>> itemResult = await db.query(
        'menu_items',
        where: 'id = ?',
        whereArgs: [itemId],
      );

      if (itemResult.isNotEmpty) {
        int currentStock = itemResult.first['stock'];

        // Check if enough stock is available
        if (currentStock < quantity) {
          print("Not enough stock to deduct.");
          return false;
        }

        int newStock = currentStock - quantity;

        // Update the stock value
        await db.update(
          'menu_items',
          {'stock': newStock},
          where: 'id = ?',
          whereArgs: [itemId],
        );

        return true;
      } else {
        print("Menu item not found.");
        return false;
      }
    } catch (e) {
      print("Error deducting stock: $e");
      return false;
    }
  }

  /// Increases stock for a specific menu item
  ///
  /// Parameters:
  /// - itemId: ID of the menu item
  /// - quantity: Quantity to add
  ///
  /// Returns:
  /// - true if successful, false otherwise
  Future<bool> addStock(int itemId, int quantity) async {
    final db = await dbHelper.database;

    try {
      // Query current stock
      List<Map<String, dynamic>> itemResult = await db.query(
        'menu_items',
        where: 'id = ?',
        whereArgs: [itemId],
      );

      if (itemResult.isNotEmpty) {
        int currentStock = itemResult.first['stock'];

        int newStock = currentStock + quantity;

        // Update the stock value
        await db.update(
          'menu_items',
          {'stock': newStock},
          where: 'id = ?',
          whereArgs: [itemId],
        );

        return true;
      } else {
        print("Menu item not found.");
        return false;
      }
    } catch (e) {
      print("Error adding stock: $e");
      return false;
    }
  }
}
