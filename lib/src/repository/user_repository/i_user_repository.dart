

import 'package:uber_clone_core/uber_clone_core.dart';

abstract  class IUserRepository {
  Future<Usuario?> getDataUserOn(String idUser);
  Future<String?> saveUserOnDatabaseOnline(String name, String idUsuario, String email,String password, String tipoUsuario);
}