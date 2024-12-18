import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class RequisitionRepository implements IRequisitionRepository {
  final _fireStoreDatabase = FirebaseFirestore.instance;
  final LocalStorage _localStorage;
  final IAppUberLog _logger;

  RequisitionRepository(
      {required IAppUberLog logger, required LocalStorage localStorage})
      : _logger = logger,
        _localStorage = localStorage;

  @override
  Future<Requisicao> verfyActivatedRequisition(String idUser) async {
    try {
      final requisicao = await _readPrefenceData(
          UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE);

      if (requisicao == null) {
        final requestActved = await findActvitesTripsById(idUser);
        final isSuccess = await saveRequisitionOnPreference(requestActved);
        if (!isSuccess) {
          const message = 'Erro ao buscar requisçao ativa';
          _logger.erro(message);
          throw RequisicaoException(message: message);
        }
        return requestActved;
      }

      return requisicao;
    } on RequisicaoException catch (e, s) {
      const message = 'Nenhuma requisição encontrado';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }


  Future<Requisicao?> _readPrefenceData(String keyPreference) async {
    final requisicao = await _localStorage.read<String>(keyPreference);
    if (requisicao == null) {
      return null;
    }

    return Requisicao.fromJson(requisicao);
  }

  @override
  Future<bool> createActiveRequisition(Requisicao requisition) async {
    try {
      await _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(requisition.passageiro.idUsuario)
          .set(requisition.dadosPassageiroToMap());

      bool? saved = await saveRequisitionOnPreference(requisition);

      return saved;
    } on FirebaseException catch (e, s) {
      const message = 'Erro ao criar viagem';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }

  @override
  Future<bool> saveRequisitionOnPreference(Requisicao requisition) async {
    final saved = await _localStorage.write<String>(
        UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE,
        requisition.toJson());
    return saved ?? false;
  }

  @override
  Future<bool> createRequisition(Requisicao requisicao) async {
    try {
      final docRef = _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .doc();

      final requisitionWithId = requisicao.copyWith(id: () => docRef.id);
      await docRef.set(requisitionWithId.dadosPassageiroToMap());
      final success = await createActiveRequisition(requisitionWithId);
      return success;
    } on FirebaseException catch (e, s) {
      const message = 'Erro ao criar requisição';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }

    //salvar dados da requisicao activa
    // _salvarRequisicaoAtiva(_idRequisicao, idUser);
    // _listenerRequisicao(_idRequisicao);
  }

  @override
  Future<bool> cancelRequisition(Requisicao requisition) async {
    final updateDataRequisition = await _fireStoreDatabase
        .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
        .doc(requisition.id)
        .update({"status": Status.CANCELADA}).then((_) async {
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
        .doc(requisition.passageiro.idUsuario);

    await docRefActive.update({"status": Status.CANCELADA});

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
  Stream<String> listenerRequisicao(String idRequisicao) async* {
    yield* _fireStoreDatabase
        .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
        .doc(idRequisicao)
        .snapshots()
        .map((data) => data["status"] as String);
  }

  @override
  Future<bool> updataDataRequisitionActiveted(
      Requisicao request, Map<Object, Object?> dataToUpdate) async {
    try {
      final doc = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(request.passageiro.idUsuario);

      await doc.update(dataToUpdate);

      await updateRequisition(request, dataToUpdate);

      final saved = await _localStorage.write<String>(
          UberCloneConstants.KEY_PREFERENCE_REQUISITION_ACTIVE,
          request.toJson());
      return saved ?? false;
    } on RequisicaoException catch (e, s) {
      const message = 'erro ao atualizar a requisiçao ativa';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }

  Future<void> updateRequisition(
      Requisicao request, Map<Object, Object?> dataToUpdate) async {
    try {
      final docReq = _fireStoreDatabase
          .collection(UberCloneConstants.REQUISITION_FIRESTORE_DATABASE_NAME)
          .doc(request.id);

      await docReq.update(dataToUpdate);
    } on Exception catch (e, s) {
      const message = 'erro ao atualizar a requisiçao';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }

  @override
  Future<List<Requisicao>> findActvitesTrips() async {
    try {
      final querySnapshot = await _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .where('status', isEqualTo: Status.AGUARDANDO)
          .get();
      final requisicoes = querySnapshot.docs.map((element) {
        return Requisicao.fromMap(element.data());
      }).toList();

      return requisicoes;
    } on RequisicaoException catch (e, s) {
      const message = 'erro ao buscar viagens ativas';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }

  @override
  Stream<List<Requisicao>> findAndObserverRequistions() async* {
    try {
      final query = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .where('status', isEqualTo: Status.AGUARDANDO);

      await for (var snapshot in query.snapshots()) {
        final request = snapshot.docs.map((docElement) {
          if (!docElement.exists) {
            _logger.erro(
                "document not exist : id : ${docElement.id} isExist : ${docElement.exists}");
            throw RequisicaoException(
                message: "dados da viagem não encontrado");
          }

          return Requisicao.fromMap(docElement.data());
        }).toList();

        yield request;
      }
    } on RequisicaoException catch (e, s) {
      _logger.erro("erro ao buscar requisição", e, s);
      throw RequisicaoException(message: e.message);
    }
  }

  @override
  Future<Requisicao> findActvitesTripsById(String idUsuario) async {
    try {
      final doc = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(idUsuario);

      final documentSnapshot = await doc.get();

      if (!documentSnapshot.exists) {
        throw RequisicaoException(
            message: "identificador não existe,requisicão não encotrada");
      }

      final snapsShot = documentSnapshot.data();
      if (snapsShot == null) {
        throw RequisicaoException(message: "Requisicão não encotrada");
      }

      return Requisicao.fromMap(snapsShot);
    } on RequisicaoException catch (e, s) {
      const message = 'erro ao encontrar requisiço ativa';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }

  @override
  Stream<Requisicao> findAndObserverRequistionbyId(Requisicao request) async* {
    try {
      final docReq = _fireStoreDatabase
          .collection(
              UberCloneConstants.REQUISITION_FIRESTORE_ACTIVE_DATABASE_NAME)
          .doc(request.passageiro.idUsuario);

      final document = docReq.snapshots();

      yield* document.map((documentSnaphot) {
        if (!documentSnaphot.exists || documentSnaphot.data() == null) {
          throw RequisicaoException(message: "Requisição não encontrado");
        }

        return Requisicao.fromMap(documentSnaphot.data()!);
      });
    } on Exception catch (e, s) {
      const message = 'Erro ao buscar a requisiçao';
      _logger.erro(message, e, s);
      throw RequisicaoException(message: message);
    }
  }
}
