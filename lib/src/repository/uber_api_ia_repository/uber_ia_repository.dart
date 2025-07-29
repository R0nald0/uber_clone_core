import 'package:uber_clone_core/src/model/Ia_request.dart';
import 'package:uber_clone_core/src/model/messages_response_suggestion.dart';

import '../../model/messages.dart';

abstract interface class UberIaRepository{
  
Future<List<MessagesResponseSuggestion>> freeChatIa(({String subject, String location , String title}) data);
   Future<Messages> sendMessageIa(IaRequest iaRequest);

    Future<List<MessagesResponseSuggestion>> getSuggestionsByUserData(
      ({
        double wheather,
        String location,
        String time,
        IaRequest iaMessage 
      }) userDataIaRequest);
       Future<MessagesResponseSuggestion> getDetailSuggestion(
      ({String title, String subject}) data) ;
}