

import 'package:uber_clone_core/src/model/Requisicao.dart';

abstract class IRequestRepository {
   Future<Requisicao> verfyActivatedRequest(String idUser);
  
   Future<List<Requisicao>> findActvitesRequest();
   Stream<List<Requisicao>> findAndObserverRequest();
   Future<Requisicao> findActvitesRequestById(String idRequisicao);
   Future<bool> createRequest(Requisicao requisicao);
   Future<bool> cancelRequest(Requisicao requisition);
   Stream<String> listenerRequest(String idRequisicao);
   Future<bool> updataDataRequestActiveted(Requisicao request,Map<Object,Object?> dataToUpdate);
   Stream<Requisicao> findAndObserverRequestbyId(Requisicao request);
  
   }
