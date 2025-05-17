import 'package:flutter/material.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';

class GlobalContext {
  late GlobalKey<NavigatorState> _navigatorKey;

   static GlobalContext? _instance; 
   GlobalContext._();
   
   static GlobalContext get i{
     if(_instance == null) {
      return GlobalContext._();
     }
     return _instance!;
   }

   set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

   Future<void> toPromoPage() async{
      // _navigatorKey.currentState?.push;
   }

}