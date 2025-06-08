import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migrations_factory.dart';


class SqlConnection {
  static const databaseVersion = 1;
  static const _databaseName = "UBER_CLONE_LOCAL_DATABASE.db";
  static SqlConnection? _instance;

  Database? _db;
  final _lock = Lock();

  SqlConnection._();

  factory SqlConnection() {
    _instance ??= SqlConnection._();
    return _instance!;
  }

  Future<Database> openConnection() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          final dataBasePath = await getDatabasesPath();
          final fullPathDatabase = join(dataBasePath, _databaseName);
          _db = await openDatabase(
            fullPathDatabase,
            version: databaseVersion,
            onCreate: onCreate,
            onConfigure: onConfigure,
            onUpgrade: onUpgrade,
          );
        }
      });
    }
    return _db!;
  }

  FutureOr<void> onUpgrade(Database db, oldVersion, newVersion) {
    final batch = db.batch();
    final migrations = MigrationsFactory().getUpdateMigration(oldVersion);
    for (var migration in migrations) {
      migration.create(batch);
    }
    batch.commit();
  }

  FutureOr<void> onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  FutureOr<void> onCreate(Database db, version) async {
    final batch = db.batch(); 
    
    final migrations = MigrationsFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch);
    }
     batch.commit();
  }
  void closeConnection() {
    _db?.close();
    _db = null;
  }


}