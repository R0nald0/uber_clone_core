import 'package:uber_clone_core/src/model/uber_messager.dart';

abstract interface class INotificationService {
   Future<void> showNotification( {String? icon ,int? progress,int? maxProgress,bool? showProgress,bool? indeterminate,
  int id = 0,required String title,required String body}) ;
  Stream<UberMessanger> getNotificationFistPlane() ;
  Future<String?> getTokenDevice();
  Future<void> requestPermission();
  Stream<String> onTokenRefresh();

}