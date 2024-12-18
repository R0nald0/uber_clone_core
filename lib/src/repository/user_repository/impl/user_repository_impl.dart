import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class UserRepositoryImpl implements IUserRepository {
  final _database = FirebaseFirestore.instance;
  final LocalStorage _localStorage;
  final IAppUberLog _log;

  UserRepositoryImpl(
      {required LocalStorage localStoreage, required IAppUberLog log})
      : _localStorage = localStoreage,
        _log = log;

  @override
  Future<Usuario?> getDataUserOn(String idUser) async {
    try {
      final isUsedLocal = await _localStorage
          .containsKey(UberCloneConstants.KEY_PREFERENCE_USER);
      if (isUsedLocal) {
        final user = await _localStorage
            .read<String>(UberCloneConstants.KEY_PREFERENCE_USER);
        return Usuario.fromJson(user!);
      }

      DocumentSnapshot snapshot = await _database
          .collection(UberCloneConstants.USUARiO_DATABASE_NAME)
          .doc(idUser)
          .get();
      final usuario = Usuario.fromFirestore(snapshot);
      final retur = await _localStorage.write("USER", usuario.toJson());
      _log.info('$retur');
      return retur == true ? usuario : null;
    } on DatabaseException catch (e, s) {
      _log.erro("Erro ao salvar no sqlIte", e, s);
      throw UserException(message: "Erro ao salvar");
    } on Exception catch (e, s) {
      _log.erro("erro ao buscas daddos do usuario", e, s);
      throw UserException(message: "erro ao buscas daddos do usuario");
    }
  }

  @override
  Future<String?> saveUserOnDatabaseOnline(String name, String idUsuario,String email, String password, String tipoUsuario) async {
    try {
      final doc =  _database
          .collection(UberCloneConstants.USUARiO_DATABASE_NAME)
          .doc(idUsuario);

      await doc.set({
        'email': email,
        'idUsuario': idUsuario,
        'nome': name,
        'tipoUsuario': tipoUsuario
      });
    
      return doc.id;
    } on UserException catch (e, s) {
      throwErrorState("erro ao salvar dados", e, s);
    }
    return null;
  }

  void throwErrorState(String message, dynamic e, StackTrace s) {
    _log.erro(message, e, s);
    throw UserException(message: message);
  }
}
