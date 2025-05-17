import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IRequistionService {
   
   Future<Requisicao> verfyActivatedRequisition(String idUser);

   Future<List<Requisicao>> findActvitesTrips();
   Future<Requisicao> findActvitesTripsById(String idRequisicao);
   Future<String> createRequisition(Requisicao requisicao);
   Future<bool> cancelRequisition(Requisicao requisition);
   Stream<String> listenerRequisicao(String idRequisicao);
   Future<Requisicao> updataDataRequisition(Requisicao request);
   Stream<List<Requisicao>> findAndObserverTrips();
   Stream<Requisicao> findAndObserverById(Requisicao request);
  Future<void> updateDataTripOn(Requisicao request);
  Future<void> delete(Requisicao request); 
  Future<bool> deleteAcvitedRequest(Requisicao request);
   


}