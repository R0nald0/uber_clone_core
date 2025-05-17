
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/service_notification_impl.dart';

class AppConfigInitialization {
    Future<void> loadConfig()async {
      WidgetsFlutterBinding.ensureInitialized();
       await _configFirebase();
       await  _initNotificationService();
    }
}

Future<void> _initNotificationService()async{
    ServiceNotificationImpl().initializedNotification();
}
 Future<void> _configFirebase() async{
   await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final notification = message.notification; 
    print("TESTE NOTOIFICATION  ${notification!.title}");
   if(notification != null) {
   ServiceNotificationImpl().showNotification(
    title: notification.title ??"teste",
    indeterminate: true, 
    showProgress: true,
    body: notification.body ?? "");
   } 
}
/* Future<void> _loadEnvs() async {
  await dotenv.load(fileName: '.env');
}
 */