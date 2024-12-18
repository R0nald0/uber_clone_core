import 'package:uber_clone_core/src/core/exceptions/requisicao_exception.dart';
import 'package:uber_clone_core/src/model/Requisicao.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/src/services/requisitionService/I_requistion_service.dart';

class RequisitonServiceImpl implements IRequistionService {
  final IRequisitionRepository _requisitionRepository;
 final ILocationRepository _locationRepositoryImpl;

  RequisitonServiceImpl({
    required IRequisitionRepository requisitonRepository,
    required ILocationRepository locationRepositoryImpl,
    })
      : _requisitionRepository = requisitonRepository,
        _locationRepositoryImpl = locationRepositoryImpl
      ;

  @override
  Future<bool> cancelRequisition(Requisicao requisition) =>
      _requisitionRepository.cancelRequisition(requisition);

  @override
  Future<bool> createActiveRequisition(Requisicao requisition) =>
      _requisitionRepository.createActiveRequisition(requisition);
  @override
  Future<bool> createRequisition(Requisicao requisicao) =>
      _requisitionRepository.createRequisition(requisicao);
  @override
  Future<List<Requisicao>> findActvitesTrips() =>
      _requisitionRepository.findActvitesTrips();

  @override
  Future<Requisicao> findActvitesTripsById(String idRequisicao) =>
      _requisitionRepository.findActvitesTripsById(idRequisicao);

  @override
  Stream<String> listenerRequisicao(String idRequisicao) =>
      _requisitionRepository.listenerRequisicao(idRequisicao);

  @override
  Future<Requisicao> updataDataRequisition(Requisicao request,Map<Object,Object?> dataToUpdate) async {
    try {
      if (request.id == null || request.motorista == null) {
        throw RequisicaoException(message: "erro ao atualizar requisição");
      }
       

      final isSuccess = await _requisitionRepository.updataDataRequisitionActiveted(request,dataToUpdate);
      if (!isSuccess) {
        throw RequisicaoException(message: 'Erro ao atualizar dados da viagem');
      }
      return await _requisitionRepository
          .findActvitesTripsById(request.passageiro.idUsuario!);
    } on RequisicaoException {
      rethrow;
    }
  }

  @override
  Future<Requisicao> verfyActivatedRequisition(String idUser) => _requisitionRepository.verfyActivatedRequisition(idUser);

  @override
  Stream<List<Requisicao>> findAndObserverTrips() =>
      _requisitionRepository.findAndObserverRequistions();

  @override
  Future<bool> saveRequisitionOnPreference(Requisicao requisition) async {
    final isSaved =  await _requisitionRepository.saveRequisitionOnPreference(requisition);
    if ( isSaved == false) {
        if (requisition.passageiro.idUsuario == null) {
           return false;
        }
       final request = await _requisitionRepository.findActvitesTripsById(requisition.passageiro.idUsuario!);
       return  await _requisitionRepository.saveRequisitionOnPreference(request);
    }
    return isSaved;
  }
  
  
  
  @override
  Stream<Requisicao> updateDataTripOn(Requisicao request,Map<Object,Object?> dataToUpdate)  async*{

    if (request.id == null || request.motorista?.idUsuario == null) {
       throw RequisicaoException(message: 'erro ao atualizar requisição');
    }
     //TODO Verificar a atualização em tempo real da requisição,
         final userPostion  = _locationRepositoryImpl.getUserRealTimeLocation();
        userPostion.listen(
          (data){
            updataDataRequisition(request,dataToUpdate); 
        });
        
    yield* _requisitionRepository.findAndObserverRequistionbyId(request);     
  }
}
