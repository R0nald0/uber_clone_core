import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IRequistionService {
   
   Future<Requisicao> verfyActivatedRequisition(String idUser);
   Future<bool> createActiveRequisition(Requisicao requisition);
   Future<List<Requisicao>> findActvitesTrips();
   Future<Requisicao> findActvitesTripsById(String idRequisicao);
   Future<bool> createRequisition(Requisicao requisicao);
   Future<bool> cancelRequisition(Requisicao requisition);
   Stream<String> listenerRequisicao(String idRequisicao);
   Future<Requisicao> updataDataRequisition(Requisicao request,Map<Object,Object?> dataToUpdate);
   Stream<List<Requisicao>> findAndObserverTrips();
   Future<bool> saveRequisitionOnPreference(Requisicao requisition); 
   Stream<Requisicao> updateDataTripOn(Requisicao request,Map<Object,Object?> dataToUpdate);
   


}