

abstract class IAppUberLog  {

  void erro(String message,[dynamic erro,StackTrace? stackTrace]);
  void info(String message,[dynamic erro,StackTrace? stackTrace]);
  void debug(String message,[dynamic erro,StackTrace? stackTrace]);
  void warnig(String message,[dynamic erro,StackTrace? stackTrace]);
   

}