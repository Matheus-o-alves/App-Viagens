// core/database/database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('travel_expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE travel_expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      expenseDate TEXT NOT NULL,
      description TEXT NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      reimbursable INTEGER NOT NULL,
      isReimbursed INTEGER NOT NULL,
      status TEXT NOT NULL,
      paymentMethod TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertTravelExpense(TravelExpenseModel expense) async {
    final db = await instance.database;
    
    return await db.insert(
      'travel_expenses',
      expense.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TravelExpenseModel>> getAllTravelExpenses() async {
    final db = await instance.database;
    
    final result = await db.query('travel_expenses', orderBy: 'expenseDate DESC');
    
    return result.map((json) => TravelExpenseModel.fromDbMap(json)).toList();
  }

  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    final db = await instance.database;
    
    final maps = await db.query(
      'travel_expenses',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return TravelExpenseModel.fromDbMap(maps.first);
    }
    
    return null;
  }

  Future<int> updateTravelExpense(TravelExpenseModel expense) async {
    final db = await instance.database;
    
    return await db.update(
      'travel_expenses',
      expense.toDbMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteTravelExpense(int id) async {
    final db = await instance.database;
    
    return await db.delete(
      'travel_expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> batchInsert(List<TravelExpenseModel> expenses) async {
    final db = await instance.database;
    final batch = db.batch();
    
    for (var expense in expenses) {
      batch.insert(
        'travel_expenses',
        expense.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    final results = await batch.commit();
    return results.length;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}