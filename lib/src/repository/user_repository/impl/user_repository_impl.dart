import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/core/exceptions/user_not_found.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class UserRepositoryImpl implements IUserRepository {
  final FirebaseFirestore _database;
  final LocalStorage _localStorage;
  final IAppUberLog _log;

  UserRepositoryImpl(
      {required FirebaseFirestore database,
      required LocalStorage localStoreage,
      required IAppUberLog log})
      : _database = database,
        _localStorage = localStoreage,
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

      Usuario usuario = await getDataUserOnFirebase(idUser);

      return await _saveUserDataOnOffLineDatabase(usuario);
    } on UserException catch (e, s) {
      _log.erro("Erro ao salvar no sqlIte", e, s);
      throw UserException(message: "Erro ao salvar");
    }
  }

  Future<Usuario?> _saveUserDataOnOffLineDatabase(Usuario usuario) async {
    try {
      final retur = await _localStorage.write("USER", usuario.toJson());

      return retur == true ? usuario : null;
    } on DatabaseException catch (e, s) {
      _log.erro("Erro ao salvar no sqlIte", e, s);
      throw UserException(message: "Erro ao salvar");
    }
  }

  Future<Usuario> getDataUserOnFirebase(String idUser) async {
    DocumentSnapshot snapshot = await _database
        .collection(UberCloneConstants.USUARiO_DATABASE_NAME)
        .doc(idUser)
        .get();

    return Usuario.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<String?> saveUserOnDatabaseOnline(String name, String idUsuario,
      String email, String password, String tipoUsuario) async {
    try {
      final doc = _database
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
      _throwErrorState("erro ao salvar dados", e, s);
    }
    return null;
  }

  void _throwErrorState(String message, dynamic e, StackTrace s) {
    _log.erro(message, e, s);
    throw UserException(message: message);
  }

  @override
  Future<bool> updateUser(Usuario usuario) async {
    try {
      final docRef = _database
          .collection(UberCloneConstants.USUARiO_DATABASE_NAME)
          .doc(usuario.idUsuario);

      await docRef.update(usuario.toMap());
      return await _localStorage.write<String>(
              UberCloneConstants.KEY_PREFERENCE_USER, usuario.toJson()) ??
          false;
    } on FirebaseException catch (e, s) {
      const message = 'Erro ao atualizar o usuário';
      _log.erro(message, e, s);
      throw UserException(message: message);
    }
  }

  @override
  Future<Usuario> findById(String id) async {
    try {
      final userDoc = await _database
          .collection(UberCloneConstants.USUARiO_DATABASE_NAME)
          .doc(id)
          .get();

      return Usuario.fromFirestore(userDoc);
    } on Exception catch (e,s) {
       log("Usuário não encontrado ",error: e,stackTrace:s );
       throw UserNotFound();
    }
  }
}
