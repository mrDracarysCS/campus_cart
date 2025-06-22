import 'package:sqflite/sqflite.dart';
import '../../models/menu_item.dart';
import '../database_helper.dart';

/// DAO for handling CRUD operations on the 'menu_items' table
class MenuItemDao {
  final dbHelper = DatabaseHelper();

  /// Inserts a new menu item
  Future<int> insertItem(MenuItem item) async {
    final db = await dbHelper.database;
    return await db.insert('menu_items', item.toMap());
  }

  /// Retrieves all items for a specific stall
  Future<List<MenuItem>> getItemsByStall(int stallId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'menu_items',
      where: 'stall_id = ?',
      whereArgs: [stallId],
    );
    return result.map((map) => MenuItem.fromMap(map)).toList();
  }

  /// Updates a menu item
  Future<int> updateItem(MenuItem item) async {
    final db = await dbHelper.database;
    return await db.update(
      'menu_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Deletes a menu item
  Future<int> deleteItem(int id) async {
    final db = await dbHelper.database;
    return await db.delete('menu_items', where: 'id = ?', whereArgs: [id]);
  }
}
