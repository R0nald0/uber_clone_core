

import 'package:flutter/material.dart';
import 'package:uber_clone_core/src/core/offline_database/sql_connection.dart';

class UberCloneLifeCycle with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final database = SqlConnection();

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        database.closeConnection();
        break;
    }

    super.didChangeAppLifecycleState(state);
  }
}
