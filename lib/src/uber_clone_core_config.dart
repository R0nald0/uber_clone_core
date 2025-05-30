import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/src/aplication_binding.dart';
import 'package:uber_clone_core/src/model/uber_messager.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/firebase_notfication.dart';
import 'package:uber_clone_core/src/services/notification_service/impl/service_notification_impl.dart';

class UberCloneCoreConfig extends StatefulWidget {
  final List<FlutterGetItModuleRouter>? modulesRouter;
  final List<FlutterGetItModule>? modules;
  final List<FlutterGetItPageRouter>? pagesRouter;
  final FlutterGetItBindings? applicationsBindings;
  final String title;
  final String initialRoute;
 
  const UberCloneCoreConfig({
    this.applicationsBindings,
    this.modules,
    this.modulesRouter,
    this.pagesRouter,
    required this.title,
    required this.initialRoute,
    super.key,
  });
   
  @override
  State<UberCloneCoreConfig> createState() =>_UberCloneCoreConfig();

}
class _UberCloneCoreConfig extends State<UberCloneCoreConfig>{
    List<FlutterGetItModule>? _modules;
    List<FlutterGetItPageRouter>? _pagesRouter;
    List<FlutterGetItModuleRouter>? _modulesRouter;
    var firebaseNotfication = FirebaseNotfication();
   late String _title;
   late String _initialRoute;

    @override
  void initState() { 
    super.initState();
     final UberCloneCoreConfig(:modules,:pagesRouter,:modulesRouter,:title,:initialRoute) = widget;
      _modules =modules;
      _pagesRouter = pagesRouter;
      _modulesRouter = modulesRouter;
      _title = title;
      _initialRoute = initialRoute;
     
     WidgetsBinding.instance.addPostFrameCallback((_) async{
       await firebaseNotfication.requestPermission();
       await firebaseNotfication.getNotificationFinishedApp();

     });
    
    
    firebaseNotfication.getNotificationFistPlane().listen((UberMessanger message){
        final UberMessanger(:body,:title,:data,:dateTime) =  message;
       ServiceNotificationImpl().showNotification(title: title ?? '', body: body ?? "");
    });

  
  }   
    
  @override
  void dispose() {
    
    super.dispose();
  }  
      @override
  Widget build(BuildContext context) {

    return FlutterGetIt(
      modulesRouter: _modulesRouter,
      modules: _modules,
      pagesRouter: _pagesRouter,
      bindings: AplicationBinding() ,
      builder: (context, routes, isReady) {
        return MaterialApp(
          title: _title,
          routes: routes,
          initialRoute: _initialRoute,
        );
      },
    );
  }
}
