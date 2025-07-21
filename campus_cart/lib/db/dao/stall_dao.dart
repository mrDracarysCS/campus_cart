import 'package:sqflite/sqflite.dart';
import '../../models/stall.dart';
import '../database_helper.dart';

/// Data Access Object (DAO) for performing CRUD operations on the 'stalls' table
class StallDao {
  final dbHelper = DatabaseHelper();

  /// Inserts a new stall into the database
  Future<int> insertStall(Stall stall) async {
    final db = await dbHelper.database;
    return await db.insert('stalls', stall.toMap());
  }

  /// Retrieves all stalls from the database
  Future<List<Stall>> getAllStalls() async {
    final db = await dbHelper.database;
    final result = await db.query('stalls');
    return result.map((map) => Stall.fromMap(map)).toList();
  }

  /// Updates a stall’s information by ID
  Future<int> updateStall(Stall stall) async {
    final db = await dbHelper.database;
    return await db.update(
      'stalls',
      stall.toMap(),
      where: 'id = ?',
      whereArgs: [stall.id],
    );
  }

  /// Deletes a stall by ID
  Future<int> deleteStall(int id) async {
    final db = await dbHelper.database;
    return await db.delete('stalls', where: 'id = ?', whereArgs: [id]);
  }
}
