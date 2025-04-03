import 'package:onfly_viagens_app/src/modules/data/model/model.dart' show TravelExpenseModel;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../data/model/travels/travel_card_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'travel_expenses.db');
    return await openDatabase(
      path,
      version: 2, 
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE travel_expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expenseDate TEXT NOT NULL,
        description TEXT,
        categoria TEXT,
        quantidade REAL,
        reembolsavel INTEGER,
        isReimbursed INTEGER,
        status TEXT,
        paymentMethod TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE travel_cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        numero TEXT,
        titular TEXT,
        validade TEXT,
        bandeira TEXT,
        limiteDisponivel REAL
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS travel_cards(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          numero TEXT,
          titular TEXT,
          validade TEXT,
          bandeira TEXT,
          limiteDisponivel REAL
        )
      ''');

      var tableInfo = await db.rawQuery("PRAGMA table_info(travel_expenses)");
      bool hasCategory = tableInfo.any((column) => column['name'] == 'category');
      bool hasAmount = tableInfo.any((column) => column['name'] == 'amount');
      bool hasReimbursable = tableInfo.any((column) => column['name'] == 'reimbursable');

      if (hasCategory || hasAmount || hasReimbursable) {
        await db.transaction((txn) async {
          await txn.execute('''
            CREATE TABLE temp_travel_expenses(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              expenseDate TEXT NOT NULL,
              description TEXT,
              categoria TEXT,
              quantidade REAL,
              reembolsavel INTEGER,
              isReimbursed INTEGER,
              status TEXT,
              paymentMethod TEXT
            )
          ''');

          await txn.execute('''
            INSERT INTO temp_travel_expenses(
              id, expenseDate, description, categoria, quantidade, reembolsavel, isReimbursed, status, paymentMethod
            )
            SELECT 
              id, expenseDate, description, 
              CASE WHEN category IS NULL THEN '' ELSE category END, 
              CASE WHEN amount IS NULL THEN 0 ELSE amount END, 
              CASE WHEN reimbursable IS NULL THEN 0 ELSE reimbursable END, 
              isReimbursed, status, paymentMethod
            FROM travel_expenses
          ''');

          await txn.execute('DROP TABLE travel_expenses');
          await txn.execute('ALTER TABLE temp_travel_expenses RENAME TO travel_expenses');
        });
      } else {
        await db.execute('ALTER TABLE travel_expenses ADD COLUMN categoria TEXT DEFAULT ""');
        await db.execute('ALTER TABLE travel_expenses ADD COLUMN quantidade REAL DEFAULT 0');
        await db.execute('ALTER TABLE travel_expenses ADD COLUMN reembolsavel INTEGER DEFAULT 0');
      }
    }
  }

  Future<List<TravelExpenseModel>> getAllTravelExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('travel_expenses');
    return List.generate(maps.length, (i) {
      return TravelExpenseModel.fromJson(maps[i]);
    });
  }

  Future<int> insertTravelExpense(TravelExpenseModel expense) async {
    final db = await database;
    return await db.insert(
      'travel_expenses',
      expense.toDatabaseMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTravelExpense(TravelExpenseModel expense) async {
    final db = await database;
    return await db.update(
      'travel_expenses',
      expense.toDatabaseMap(), 
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteTravelExpense(int id) async {
    final db = await database;
    return await db.delete(
      'travel_expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<TravelExpenseModel?> getTravelExpenseById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'travel_expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return TravelExpenseModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> batchInsertExpenses(List<TravelExpenseModel> expenses) async {
    final db = await database;
    final Batch batch = db.batch();

    for (var expense in expenses) {
      batch.insert(
        'travel_expenses',
        expense.toDatabaseMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TravelCardModel>> getAllTravelCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('travel_cards');
    return List.generate(maps.length, (i) {
      return TravelCardModel.fromJson(maps[i]);
    });
  }

  Future<int> insertTravelCard(TravelCardModel card) async {
    final db = await database;
    return await db.insert(
      'travel_cards',
      card.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTravelCard(TravelCardModel card) async {
    final db = await database;
    return await db.update(
      'travel_cards',
      card.toJson(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<TravelCardModel?> getTravelCardById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'travel_cards',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return TravelCardModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> batchInsertCards(List<TravelCardModel> cards) async {
    if (cards.isEmpty) {
      return;
    }

    final db = await database;
    final Batch batch = db.batch();

    try {
      for (var card in cards) {
        batch.insert(
          'travel_cards', 
          card.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();
    } catch (_) {
      for (var card in cards) {
        try {
          await insertTravelCard(card);
        } catch (_) {}
      }
    }
  }
}
