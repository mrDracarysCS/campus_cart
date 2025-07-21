import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton class to manage SQLite database connection
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// Returns a database instance; opens one if not already open
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and sets up the tables
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'campus_cart.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Creates all necessary tables in the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stalls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE menu_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stall_id INTEGER,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        FOREIGN KEY (stall_id) REFERENCES stalls(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_name TEXT,
        status TEXT NOT NULL, -- e.g., pending, in_progress, ready
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        item_id INTEGER,
        quantity INTEGER,
        FOREIGN KEY (order_id) REFERENCES orders(id),
        FOREIGN KEY (item_id) REFERENCES menu_items(id)
      )
    ''');
  }

  /// Optional: clears all data (for development reset)
  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('order_items');
    await db.delete('orders');
    await db.delete('menu_items');
    await db.delete('stalls');
  }
}
