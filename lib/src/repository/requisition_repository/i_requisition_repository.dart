

import 'package:uber_clone_core/src/model/Requisicao.dart';

abstract class IRequisitionRepository {
   Future<Requisicao> verfyActivatedRequisition(String idUser);
   Future<bool> createActiveRequisition(Requisicao requisition);
   Future<List<Requisicao>> findActvitesTrips();
   Stream<List<Requisicao>> findAndObserverRequistions();
   Future<Requisicao> findActvitesTripsById(String idRequisicao);
   Future<bool> createRequisition(Requisicao requisicao);
   Future<bool> cancelRequisition(Requisicao requisition);
   Stream<String> listenerRequisicao(String idRequisicao);
   Future<bool> updataDataRequisitionActiveted(Requisicao request,Map<Object,Object?> dataToUpdate);
   Future<bool> saveRequisitionOnPreference(Requisicao requisition) ;

   Stream<Requisicao> findAndObserverRequistionbyId(Requisicao request);
  
   }
