import 'package:uber_clone_core/src/core/exceptions/request_not_found.dart';
import 'package:uber_clone_core/src/core/exceptions/requisicao_exception.dart';
import 'package:uber_clone_core/src/core/exceptions/user_exception.dart';
import 'package:uber_clone_core/src/core/exceptions/user_not_found.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/model/Requisicao.dart';
import 'package:uber_clone_core/src/repository/auth_repository/I_auth_repository.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/i_user_repository.dart';
import 'package:uber_clone_core/src/services/requisitionService/I_requistion_service.dart';

class RequisitonServiceImpl implements IRequistionService {
  final IRequestRepository _requisitionRepository;
  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final IAppUberLog _log;

  RequisitonServiceImpl({
    required IRequestRepository requisitonRepository,
    required IUserRepository userRepository,
    required IAuthRepository authRepository,
    required IAppUberLog log,
  })  : _requisitionRepository = requisitonRepository,
        _userRepository = userRepository,
        _authRepository = authRepository,
        _log = log;

  @override
  Future<bool> cancelRequisition(Requisicao requisition) =>
      _requisitionRepository.cancelRequest(requisition);

  @override
  Future<String> createRequisition(Requisicao requisicao) =>
      _requisitionRepository.createRequestActive(requisicao);
  @override
  Future<List<Requisicao>> findActvitesTrips() =>
      _requisitionRepository.findActvitesRequest();

  @override
  Future<List<Requisicao>> findAllFromUser(String id) =>
      _requisitionRepository.findAllFromUser(id);
  @override
  Future<Requisicao> findActvitesTripsById(String idRequisicao) =>
      _requisitionRepository.findActvitesRequestById(idRequisicao);

  @override
  Stream<String> listenerRequisicao(String idRequisicao) =>
      _requisitionRepository.listenerRequest(idRequisicao);

  @override
  Future<Requisicao> updataDataRequisition(Requisicao request) async {
    try {
      if (request.id == null) {
        throw RequestException(
            message: "Erro ao atualizar requisição,id inválido");
      }

      final isSuccess =
          await _requisitionRepository.updataDataRequestActiveted(request);
      // final isSuccess = await _requisitionRepository.deleteAcvitedRequest(request);

      if (!isSuccess) {
        deleteAcvitedRequest(request);
        throw RequestException(message: 'Erro ao atualizar dados da viagem');
      }
      return await _requisitionRepository.findActvitesRequestById(request.id!);
    } on RequestNotFound {
      rethrow;
    } on RequestException {
      rethrow;
    }
  }

  @override
  Future<Requisicao> verfyActivatedRequisition(String idRequestActive) async {
    try {
      return  await _requisitionRepository.verfyActivatedRequest(idRequestActive);
    } on RequestNotFound {
     // await _updateUserWhenRequestNotFound();
      rethrow;
    }on RequestException {
        rethrow;
    }
  }

  Future<void> _updateUserWhenRequestNotFound() async {
     final id = _authRepository.getIdCurrenteUserUser();
    if (id == null) {
      throw UserNotFound();
    }
    
    final user = await _userRepository.getDataUserOn(id);
    final userUpdated = user?.copyWith(idRequisicaoAtiva: () => "");
    if (userUpdated == null) {
      throw UserNotFound();
    }
    _userRepository.updateUser(userUpdated);
  }

  @override
  Stream<List<Requisicao>> findAndObserverTrips() =>
      _requisitionRepository.findAndObserverRequest();

  @override
  Future<void> updateDataTripOn(Requisicao request) =>
      _requisitionRepository.updateUserPositionRequestActiveted(request);

  @override
  Stream<Requisicao> findAndObserverById(Requisicao request) =>
      _requisitionRepository.findAndObserverRequestbyId(request);

  @override
  Future<void> delete(Requisicao request) =>
      _requisitionRepository.delete(request);

  @override
  Future<bool> deleteAcvitedRequest(Requisicao request) async {
    try {
      final isdeleted =
          await _requisitionRepository.deleteAcvitedRequest(request);
      if (!isdeleted) {
        return isdeleted;
      }

      final idUser = await _authRepository.verifyStateUserLogged();
      if (idUser == null) {
        throw UserException(message: "erro ao atualizar Dados do usuario");
      }

      final user = await _userRepository.getDataUserOn(idUser);

      if (user == null) {
        throw UserException(message: "erro ao atualizar Dados do usuario");
      }
      final userUpdated = user.copyWith(idRequisicaoAtiva: () => '');

      return _userRepository.updateUser(userUpdated);
    } on UserException catch (e, s) {
      _log.erro("erro ao atualizar dados do usario", e, s);
      throw UserException(message: e.message);
    } on RequestException catch (e, s) {
      _log.erro("erro ao atualizar dados do usario", e, s);
      throw RequestException(message: "erro ao atualizar dados do usario");
    }
  }
}
