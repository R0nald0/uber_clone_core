import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/core/offline_database/database_off_line.dart';
import 'package:uber_clone_core/src/core/offline_database/sql_connection.dart';
import 'package:uber_clone_core/src/model/Usuario.dart';


class DatabaseImpl implements DatabaseOffLine {

  final _sqlConnection = SqlConnection();

  @override
  Future<void> delete(Usuario usuario) {
    // TODO: implement delete
    throw UnimplementedError();
  }


  @override
  Future<List<Map<String, Object?>>> getUserData(String $tableName) async {
      try {
          final db  = await  _sqlConnection.openConnection();
          final mapResults = await db.query($tableName);
           return mapResults; 
      } on DatabaseException {
          rethrow;
      }
  }

  @override
  Future<int> save(String query,List<Object?>? arguments) async {
   try {
      final data = await _sqlConnection.openConnection();
    
    /* 'INSERT INTO usuario VALUES(?,?,?,?,?)' 
       [
      usuario.idUsuario,
      usuario.email,
      usuario.nome,
      usuario.latitude.toString(),
      usuario.longitude.toString()
    ]
    */
    return await data.rawInsert(query,arguments);
   } on DatabaseException  {
      rethrow;
   }
  }

  @override
  Future<Usuario> update(Usuario usuario) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
