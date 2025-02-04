

import 'package:uber_clone_core/src/model/Usuario.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/user_service/i_user_service.dart';

class UserServiceImpl implements IUserService {
  final IUserRepository _userRepository;

  UserServiceImpl({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Usuario?> getDataUserOn(String idUser) =>
      _userRepository.getDataUserOn(idUser);

  @override
  Future<void> saveUserOnDatabaseOnline(
    String name, 
    String idUsuario, 
    String email, 
    String password, 
    String tipoUsuario) =>
      _userRepository.saveUserOnDatabaseOnline( name, idUsuario, email, password, tipoUsuario);
      
        @override
        Future<bool> updateUser(Usuario usuario) => _userRepository.updateUser(usuario);
}
