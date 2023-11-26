import 'dart:async';

// import 'dart:core';

import 'package:path/path.dart';
import 'package:quiestce/models/employe.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  static Database? _database;

  Future get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    final path = join(await getDatabasesPath(), 'ressourcehumain.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createTables(Database db, int version) async {
    try {
      // creation de la table ressourcehumaine
      await db.execute(
          '''CREATE TABLE IF NOT EXISTS Employe (id INTEGER PRIMARY KEY , nom TEXT , prenom TEXT , numero INTEGER , email TEXT , adresse TEXT , poste TEXT , date TEXT , image BLOB , pdfcv BLOB ,pdfFilePath TEXT)''');
    } catch (e) {
      print(e);
    }
  }

  // creation d'un employe return 1 si  c'est enregistré
  Future<int> createEmploye(Employe employe) async {
    final db = await database;
    var result = await db.insert('Employe', employe.toMap());
    return result;
  }

  // afficher tous les employées

  Future<List<Employe>> getEmploye() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Employe');

    return List.generate(maps.length, (index) {
      return Employe.fromMap(maps[index]);
    });
  }
  // affiche employe specifique

  Future<Employe?> getIntEmploye(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Employe',
      where: 'id = ?',
      whereArgs: [id],
    );

     if (maps.isNotEmpty) {
      return Employe.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // supprimez employe

   Future<int> deleteEmploye(int id) async {
    final db = await database;
    final result = await db.delete('Employe', where: 'id = ?', whereArgs: [id]);

    return result;
  }

  // mettre a jour une employe
  Future<int> updateEmploye(Employe employe) async {
    final db = await database;
    final result = await db.update('Employe', employe.toMap(),
        where: 'id = ?', whereArgs: [employe.id]);

    return result;
  }

  // recup employe detecter avec son image

  // mise a jour

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
       final result = await db.rawQuery("PRAGMA table_info('Employe')");
       final columnExists = result.any((column) => column['name'] == 'pdfcv');
       final col = result.any((column) => column['name'] == 'pdfFilePath');
       if (!col) {
        await db.execute('ALTER TABLE Employe ADD COLUMN pdfFilePath TEXT');
      }

      if (!columnExists) {
        await db.execute('ALTER TABLE Employe ADD COLUMN pdfcv BLOB');
      }
      final employe = await db.rawQuery("PRAGMA table_info('Employe')");
      final employeExists = employe.isNotEmpty;
      if (!employeExists) {
        await _createTables(db, newVersion);
      }

      await db.execute('PRAGMA user_version = $newVersion');
    }
  }
}
