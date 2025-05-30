

import 'package:uber_clone_core/src/model/usuario.dart';

abstract interface class IUserService {
   Future<Usuario?> getDataUserOn(String idUser);
   Future<void> saveUserOnDatabaseOnline(String name, String idUsuario, String email, String password, String tipoUsuario);
 
  Future<bool> updateUser(Usuario usuario);
}