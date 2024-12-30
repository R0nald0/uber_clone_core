

import 'package:uber_clone_core/src/model/Usuario.dart';

abstract interface class UserService {
   Future<Usuario?> getDataUserOn(String idUser);
   Future<void> saveUserOnDatabaseOnline(String name, String idUsuario, String email, String password, String tipoUsuario);
 
  Future<bool> updateUser(Usuario usuario);
}