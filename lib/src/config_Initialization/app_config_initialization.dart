
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfigInitialization {
    Future<void> loadConfig()async {
    WidgetsFlutterBinding.ensureInitialized();
  
       await _loadEnvs();
    }
}


Future<void> _loadEnvs() async {
  await dotenv.load(fileName: '.env');
}