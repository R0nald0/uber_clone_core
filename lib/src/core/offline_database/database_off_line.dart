

import 'package:uber_clone_core/src/model/usuario.dart';

abstract class DatabaseOffLine {
   
  Future<int> save(String query,List<Object?>? arguments);
  Future<Usuario> update(Usuario usuario);
   Future<List<Map<String, Object?>>> getUserData(String tableName);
  Future<void> delete(Usuario usuario);

}