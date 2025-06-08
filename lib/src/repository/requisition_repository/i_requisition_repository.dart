import 'package:uber_clone_core/src/model/Requisicao.dart';

abstract class IRequestRepository {
  Future<Requisicao> verfyActivatedRequest(String idRequestActive);
  Future<List<Requisicao>> findAllFromUser(String id);

  Future<List<Requisicao>> findActvitesRequest();
  Stream<List<Requisicao>> findAndObserverRequest();
  Stream<Requisicao> findAndObserverRequestbyId(Requisicao request);
   
  Future<Requisicao> findActvitesRequestById(String idRequisicao);
  Future<String> createRequestActive(Requisicao requisicao);
  Future<bool> cancelRequest(Requisicao requisition);
  Stream<String> listenerRequest(String idRequisicao);
  Future<bool> updataDataRequestActiveted(Requisicao request);
  Future<void> updateUserPositionRequestActiveted(Requisicao request);
 
  Future<void> delete(Requisicao request);
  Future<bool> deleteAcvitedRequest(Requisicao request);
}
