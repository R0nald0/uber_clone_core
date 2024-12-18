import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/core/exceptions/user_exception.dart';
import 'package:uber_clone_core/src/core/local_storage/local_storage.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/repository/auth_repository/I_auth_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/authservice/i_auth_service.dart';

class AuthServiceImpl implements IAuthService {
  final LocalStorage _localStorage;
  final IAppUberLog _log;
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;

  AuthServiceImpl(
      {required LocalStorage localStorage,
      required IAppUberLog log,
      required IAuthRepository authrepository,
      required IUserRepository userRepository})
      : _localStorage = localStorage,
        _log = log,
        _authRepository = authrepository,
        _userRepository = userRepository;

  @override
  Future<bool> register(
      String name, String email, password, String tipoUsuario) async {
    try {
      final uid = await _authRepository.register(name, email, password);
      if (uid == null) {
        logout();
        throw UserException(message: 'Erro ao registrar usuário');
      }

      final idFireStore = await _userRepository.saveUserOnDatabaseOnline(
          name, uid, email, password, tipoUsuario);

      if (idFireStore == null) {
        logout();
        return false;
      }
      return await _getDataUserOnFireBaseAndSaveDataLocal(idFireStore);
    } on UserException {
      rethrow;
    }
  }

  Future<bool> _getDataUserOnFireBaseAndSaveDataLocal(String idFireStore) async {
    final user = await _userRepository.getDataUserOn(idFireStore);

    if (user == null) {
      return false;
    }

    return await _localStorage.write<String>(
            UberCloneConstants.USUARiO_DATABASE_NAME, user.toJson()) ??
        false;
  }

  @override
  Future<bool> login(String email, password) async {
    try {
      final uid = await _authRepository.logar(email, password);
      if (uid == null) {
        logout();
        throw UserException(message: 'Erro ao logar usuario');
      }

      return await _getDataUserOnFireBaseAndSaveDataLocal(uid);
    } on UserException {
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      _authRepository.logout();
      final isRemoved =
          await _localStorage.remove(UberCloneConstants.KEY_PREFERENCE_USER);
      if (isRemoved == null || isRemoved == false) {
        throw UserException(message: 'Erro ao remover dados do usúario');
      }
      return isRemoved;
    } on UserException catch (e, s) {
      const message = 'Erro ao remover dados do usúario';
      _log.erro(message, e, s);
      throw UserException(message: message);
    }
  }

  @override
  Future<String?> verifyStateUserLogged() async {
    return await _authRepository.verifyStateUserLogged();
  }
}
