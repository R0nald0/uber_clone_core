 
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

part 'location_controller.g.dart';

class LocationController = LocationControllerBase  with _$LocationController ;

abstract class LocationControllerBase with Store {
   
  @readonly
  LocationPermission? _locationPermission;

  @readonly
  bool _isServiceEnable = false;

   
   @action
   Future<void> getPermissionLocation() async {
        
    _locationPermission = null;
   

    final isServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnable) {
      _isServiceEnable = isServiceEnable;
      return;
    }

    _isServiceEnable = isServiceEnable;

    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _locationPermission = permission;
          return;
        } 
        break;
      
      case LocationPermission.deniedForever:
        _locationPermission = LocationPermission.deniedForever;
        return;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
    
      break;
     
    }

  }

}
