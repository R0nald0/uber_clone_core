
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/service_notification_impl.dart';

class AppConfigInitialization {
    Future<void> loadConfig()async {
      WidgetsFlutterBinding.ensureInitialized();
       await _configFirebase();
       await  _initNotificationService();
       await _loadEnvs(); 
    }
}

Future<void> _initNotificationService()async{
    ServiceNotificationImpl().initializedNotification();
}
 Future<void> _configFirebase() async{
   await Firebase.initializeApp();
}
Future<void> _loadEnvs() async {
  await dotenv.load(fileName: '.env');
}
