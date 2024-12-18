import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/src/config_Initialization/app_config_initialization.dart';
import 'package:uber_clone_core/src/aplication_binding.dart';

class UberCloneCoreConfig extends StatelessWidget {
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
  Widget build(BuildContext context) {
   AppConfigInitialization();

    return FlutterGetIt(
      modulesRouter: modulesRouter,
      modules: modules,
      pagesRouter: pagesRouter,
      bindings: AplicationBinding() ,
      builder: (context, routes, isReady) {
        return MaterialApp(
          title: title,
          routes: routes,
          initialRoute: initialRoute,
        );
      },
    );
  }
}
