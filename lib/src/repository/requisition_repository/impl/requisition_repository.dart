import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class RequisitionRepository implements IRequestRepository {
  final FirebaseFirestore _fireStoreDatabase;
  final LocalStorage _localStorage;
  final IAppUberLog _logger;

  RequisitionRepository(
      {required FirebaseFirestore firestore,
      required IAppUberLog logger,
      required LocalStorage localStorage})
      : _fireStoreDatabase = firestore,
        _logger = logger,
        _localStorage = localStorage;

  @override
  Future<Requisicao> verfyActivatedRequest(String idRequestActive) async {
    try {
      final requisicao = await _readPrefenceData(
          UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE);

      if (requisicao == null) {
        final requestActved = await findActvitesRequestById(idRequestActive);
        final isSuccess = await _saveRequisitionOnPreference(requestActved);
        if (!isSuccess) {
          throw RequestNotFound();
        }
        return requestActved;
      }

      return requisicao;
    } on RequestNotFound catch (e, s) {
      const message = 'Nenhuma requisição encontrado com este id';
      _logger.erro(message, e, s);
      rethrow;
    } on ArgumentError {
      throw RequestNotFound();
    }
  }

  Future<Requisicao?> _readPrefenceData(String keyPreference) async {
    try {
      final requisicao = await _localStorage.read<String>(keyPreference);

      if (requisicao == null) {
        return null;
      }

      return Requisicao.fromJson(requisicao);
    } on ArgumentError catch (e, s) {
      log("Erro ao conveter json", error: e, stackTrace: s);
      throw ArgumentError();
    }
  }

  Future<bool> _saveOndRequestList(Requisicao requisition) async {
    try {
      final docRef = _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .doc(requisition.id);

      await docRef.set(requisition.toMap());

      return await _saveRequisitionOnPreference(requisition);
    } on FirebaseException catch (e, s) {
      const message = 'Erro ao criar viagem';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  Future<bool> _saveRequisitionOnPreference(Requisicao requisition) async {
    try {
      final isSuccess = await _localStorage.write<String>(
          UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE,
          requisition.toJson());

      return isSuccess != true ? false : true;
    } on DatabaseException catch (e, s) {
      const message = 'erro ao salvar dados da requisição';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<String> createRequestActive(Requisicao requisicao) async {
    try {
      final docRef = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc();

      final requisitionWithId = requisicao.copyWith(id: () => docRef.id);
      await docRef.set(requisitionWithId.toMap());
      
      final saved = await _saveOndRequestList(requisitionWithId);

      if (!saved) {
        deleteAcvitedRequest(requisicao);
        throw RequestException(message: "Erro salvar requisição no banco");
      }
      return docRef.id;
    } on FirebaseException catch (e, s) {
      const message = 'Erro ao criar requisição';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    } on RequestException catch (e, s) {
      const message = 'Erro ao criar requisição local storage';
      _logger.erro(message, e, s);
      throw RequestException(message: e.message);
    }

    //salvar dados da requisicao activa
    // _salvarRequisicaoAtiva(_idRequisicao, idUser);
    // _listenerRequisicao(_idRequisicao);
  }

  @override
  Future<bool> cancelRequest(Requisicao requisition) async {
    final updateDataRequisition = await _fireStoreDatabase
        .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
        .doc(requisition.id)
        .update({"status": RequestState.cancelado.value}).then((_) async {
      return true;
    }, onError: (e) {
      _logger.erro("Erro ao atualizar requsição");
      return false;
    });

    if (!updateDataRequisition) {
      return false;
    }

    final docRefActive = _fireStoreDatabase
        .collection(
            UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
        .doc(requisition.id);

    await docRefActive.update({"status": RequestState.cancelado.value});

    return await docRefActive.delete().then((_) async {
      final isRemoved = await _localStorage
          .remove(UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE);
      if (isRemoved == null || isRemoved == false) {
        return false;
      }

      return true;
    }, onError: (e) {
      _logger.erro("Erro ao cancelar requsição");
      return false;
    });
  }

  @override
  Stream<String> listenerRequest(String idRequisicao) async* {
    yield* _fireStoreDatabase
        .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
        .doc(idRequisicao)
        .snapshots()
        .map((data) => data["status"] as String);
  }

  @override
  Future<bool> updataDataRequestActiveted(Requisicao request) async {
    try {
      final doc = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(request.id);

      await doc.update(request.toMap());

      await _updateRequisition(request);

      final saved = await _localStorage.write<String>(
          UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE,
          request.toJson());

      return saved ?? false;
    } on RequestException catch (e, s) {
      const message = 'erro ao atualizar a requisiçao ativa';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<void> updateUserPositionRequestActiveted(Requisicao request) async {
    try {
      final docRef = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(request.id!);

      await docRef.update(request.toMap());
    } on RequestException catch (e, s) {
      const message = 'erro ao atualizar a requisiçao ativa';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    } on ArgumentError catch (e, s) {
      _logger.erro('Erro ao converter map', e.message, s);
      throw RequestException(message: "Erro ao atualizar ao a requisição");
    }
  }

  Future<void> _updateRequisition(Requisicao request) async {
    try {
      final docReq = _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .doc(request.id);

      await docReq.update(request.toMap());
    } on Exception catch (e, s) {
      const message = 'erro ao atualizar a requisiçao';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<List<Requisicao>> findActvitesRequest() async {
    try {
      final querySnapshot = await _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .where('status', isEqualTo: RequestState.aguardando.value)
          .get();
      final requisicoes = querySnapshot.docs.map((element) {
        return Requisicao.fromMap(element.data());
      }).toList();

      return requisicoes;
    } on RequestException catch (e, s) {
      const message = 'erro ao buscar viagens ativas';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Stream<List<Requisicao>> findAndObserverRequest() async* {
    try {
      final query = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .where('status', isEqualTo: RequestState.aguardando.value);

      await for (var snapshot in query.snapshots()) {
        final request = snapshot.docs.map((docElement) {
          if (!docElement.exists) {
            _logger.erro(
                "document not exist : id : ${docElement.id} isExist : ${docElement.exists}");
            throw RequestException(message: "dados da viagem não encontrado");
          }

          return Requisicao.fromMap(docElement.data());
        }).toList();

        yield request;
      }
    } on RequestException catch (e, s) {
      _logger.erro("erro ao buscar requisição", e, s);
      throw RequestException(message: e.message);
    } on ArgumentError catch(e,s){
        _logger.erro("Ison inválido", e, s);
      throw RequestException(message: e.message);
    };
  }

  @override
  Future<Requisicao> findActvitesRequestById(String idRequest) async {
    try {
      final doc = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(idRequest);

      final documentSnapshot = await doc.get();

      if (!documentSnapshot.exists) {
        throw RequestNotFound();
      }

      final snapsShot = documentSnapshot.data();
      if (snapsShot == null) {
        throw RequestNotFound();
      }

      return Requisicao.fromMap(snapsShot);
    } 
    on RequestNotFound catch (e, s) {
      const message = 'erro ao encontrar requisição ativa';
      _logger.erro(message, e, s);
      throw RequestNotFound();
    } on ArgumentError {
      throw RequestNotFound();
    }
  }

  @override
  Stream<Requisicao> findAndObserverRequestbyId(Requisicao request) async* {
    try {
      final docReq = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(request.id);

      final document = docReq.snapshots();

      if (await document.isEmpty) {
        throw RequestException(message: "Erro ao buscar dados requisição");
      }

      final requi = document.map((documentSnaphot) {
        if (!documentSnaphot.exists || documentSnaphot.data() == null) {
          throw RequestException(message: "Erro ao buscar dados requisição");
        }
        return Requisicao.fromMap(documentSnaphot.data()!);
      });

      yield* requi;
    } on RequestException catch (e, s) {
      const message = 'Erro ao buscar a requisiçao';
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<void> delete(Requisicao request) async {
    try {
      final doc = _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .doc(request.id);
      await doc.delete();
    } on FirebaseException catch (e, s) {
      const message = " Erro ao deletar a requisição";
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<bool> deleteAcvitedRequest(Requisicao request) async {
    try {
      final isDeleted = await _localStorage
          .remove(UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE);

      if (isDeleted == true) {
        final doc = _fireStoreDatabase
            .collection(
                UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
            .doc(request.id);
        await doc.delete();
      }

      return isDeleted ?? false;
    } on FirebaseException catch (e, s) {
      const message = " Erro ao deletar a requisição";
      _logger.erro(message, e, s);
      throw RequestException(message: message);
    }
  }

  @override
  Future<List<Requisicao>> findAllFromUser(String id) async {
    try {
      final QuerySnapshot(:docs) = await _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .where('motorista.idUsuario', isEqualTo: id).get();

      if (docs.isEmpty) {
        return List.empty();
      }

    return  docs.map((doc) {
        return Requisicao.fromMap(doc.data());
    }).toList();

    } on FirebaseException catch (e, s) {
      log('Erro ao buscar dados no firebase', error: e, stackTrace: s);
      throw RequestException(message: 'Erro ao buscar dados do usuário');
    } on ArgumentError catch (e, s) {
      log('Erro ao converter json', error: e, stackTrace: s);
      throw RequestException(message: 'Erro ao buscar dados do usuário');
    }
  }
}
