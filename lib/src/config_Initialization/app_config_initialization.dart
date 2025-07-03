import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/service_notification_impl.dart';

class AppConfigInitialization {
    Future<void> loadConfig()async {

    WidgetsFlutterBinding.ensureInitialized();
    await _configFirebase();
    await initializeDateFormatting('pt_BR', null);
   // await initStripe();
    
   }
}

Future<void> initStripe()async{
   Stripe.publishableKey =const String.fromEnvironment("PUBLISHED_KEY");
}


 Future<void> _configFirebase() async{
   await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final RemoteMessage(:notification) = message; 

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