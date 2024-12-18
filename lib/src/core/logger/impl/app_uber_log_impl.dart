

import 'package:logger/logger.dart';

import '../i_app_uber_log.dart';

class AppUberLogImpl  implements IAppUberLog{
   final  Logger _log = Logger();

  @override
  void debug(String message, [erro, StackTrace? stackTrace]) {
    _log.d(message,error: erro,stackTrace: stackTrace);
  }

  @override
  void erro(String message, [erro, StackTrace? stackTrace]) {
     _log.e(message,error: erro,stackTrace: stackTrace);
  }

  @override
  void info(String message, [erro, StackTrace? stackTrace]) {
     _log.i(message,error: erro,stackTrace: stackTrace);
  }

  @override
  void warnig(String message, [erro, StackTrace? stackTrace]) {
     _log.i(message,error: erro,stackTrace: stackTrace);
  }

}