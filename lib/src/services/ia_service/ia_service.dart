
import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IaService{
  Future<List<MessagesResponseSuggestion>> freeChatIa(
      ({ String subject, String title}) messageData,Usuario user); 
  Future<List<MessagesResponseSuggestion>> sendMessage(String message,Usuario user);
  Future<MessagesResponseSuggestion> getDetailSuggestion(({String title, String subject}) data);

}