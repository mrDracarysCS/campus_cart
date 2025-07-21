import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

/// Class to insert dummy data into the database for testing
class DataSeeder {
  final dbHelper = DatabaseHelper();

  /// Clears all data and populates stalls, items, and one order
  Future<void> seedData() async {
    final db = await dbHelper.database;

    // Optional: clear previous data
    await db.delete('order_items');
    await db.delete('orders');
    await db.delete('menu_items');
    await db.delete('stalls');

    // Insert dummy stalls
    int burgerStallId = await db.insert('stalls', {
      'name': 'Burger Bros',
      'description': 'Fast grilled burgers and fries',
    });

    int sushiStallId = await db.insert('stalls', {
      'name': 'Sushi Express',
      'description': 'Fresh sushi and poke bowls',
    });

    // Insert dummy menu items
    int burgerId = await db.insert('menu_items', {
      'stall_id': burgerStallId,
      'name': 'Cheeseburger',
      'price': 5.99,
      'stock': 20,
    });

    int friesId = await db.insert('menu_items', {
      'stall_id': burgerStallId,
      'name': 'Fries',
      'price': 2.49,
      'stock': 30,
    });

    int rollId = await db.insert('menu_items', {
      'stall_id': sushiStallId,
      'name': 'California Roll',
      'price': 6.50,
      'stock': 15,
    });

    // Insert a dummy order
    int orderId = await db.insert('orders', {
      'student_name': 'Alice',
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('order_items', {
      'order_id': orderId,
      'item_id': burgerId,
      'quantity': 2,
    });

    await db.insert('order_items', {
      'order_id': orderId,
      'item_id': friesId,
      'quantity': 1,
    });

    print("Dummy data seeded successfully.");
  }
}
