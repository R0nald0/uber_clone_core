import 'dart:async';
import 'dart:ui';

class Debaunce {
  final int milliseconds;
  Timer? _timer;

  Debaunce({required this.milliseconds});

  void run(VoidCallback action){
    if (_timer != null) {
        _timer!.cancel();
    }
    
    _timer  = Timer(Duration(milliseconds: milliseconds), action);
  }
 
}