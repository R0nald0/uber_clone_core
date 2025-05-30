import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/service_notification_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class FirebaseNotfication{
  final _firebaseMessage = FirebaseMessaging.instance;

   
  FirebaseNotfication(){
      _initFirebasMessageConfig();
  }

  Future<void> _initFirebasMessageConfig() async{
    _firebaseMessage.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
  }
  
  Future<void> requestPermission() async {
    final notificationSetting = await _firebaseMessage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    notificationSetting.authorizationStatus.name;
  }


  Stream<UberMessanger> getNotificationFistPlane() async* {
    yield*  FirebaseMessaging.onMessage.asyncMap(
      (messanger) => UberMessanger.toUberMessanger(
      messanger.notification?.title, 
      messanger.notification?.body, 
      messanger.notification?.android?.imageUrl, 
      messanger.sentTime, 
      messanger.notification?.android?.smallIcon,
      messanger.data
      ));
  }
   
  Future<void> getNotificationFinishedApp() async{
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  
    final uberMessage = UberMessanger.toUberMessanger(
      message.notification?.title, 
      message.notification?.body, 
      message.notification?.android?.imageUrl, 
      message.sentTime, 
      message.notification?.android?.smallIcon,
      message.data
      );
     ServiceNotificationImpl().showNotification(title: uberMessage.title!, body:uberMessage.body!);
    });
  }

  Stream<String> onTokenRefresh() async* {
    yield* _firebaseMessage.onTokenRefresh;
  }

  Future<String?> getTokenDevice() =>_firebaseMessage.getToken();   

}