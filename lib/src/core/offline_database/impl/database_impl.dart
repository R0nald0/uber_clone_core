import 'dart:async';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/core/offline_database/database_off_line.dart';
import 'package:uber_clone_core/src/core/offline_database/sql_connection.dart';

class DatabaseImpl implements DatabaseOffLine {
  final _sqlConnection = SqlConnection();

  @override
  Future<int> delete(String tableName, String idData) async {
    try {
      final db = await _sqlConnection.openConnection();
      return db.rawDelete('DELETE FROM $tableName WHERE id =?', [idData]);
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> findAllData(String $tableName) async {
    try {
      final db = await _sqlConnection.openConnection();
      final mapResults = await db.query($tableName);
      return mapResults;
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> save(String query, List<Object?>? arguments) async {
    try {
      final data = await _sqlConnection.openConnection();
      return await data.rawInsert(query, arguments);
    } on DatabaseException catch (e, s) {
      log("Erro ao salvdar dado localmente", error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<int> update(String tableName, List<Object?>? arguments) async {
    try {
      final db = await _sqlConnection.openConnection();
      return await db.rawUpdate(tableName, arguments);
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> clearTable(String tableName) async {
    try {
      final db = await _sqlConnection.openConnection();
    return  await db.rawDelete('DELETE FROM $tableName');
    } on DatabaseException {
      rethrow;
    }
  }
}
