
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/services/notification_service/i_notification_service.dart';

class ServiceNotificationImpl implements INotificationService {
  
  final _notificationPugin = FlutterLocalNotificationsPlugin();
  
  static  ServiceNotificationImpl? _i ;

  ServiceNotificationImpl._(){
     _initializedNotification();
   }

  factory ServiceNotificationImpl(){
     _i ??= ServiceNotificationImpl._();
     return _i!;
   }

  Future<void> _initializedNotification()  async{
    const initializedSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializeIOSSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );
    const initisetting = InitializationSettings(
      android: initializedSettingsAndroid,
      iOS: initializeIOSSetting
    );
    _notificationPugin.initialize(initisetting);
  }
  NotificationDetails _initializeDetailsNotification(String? icon,int? progress,int? maxProgress,bool? showProgress,bool? indeterminate){
    
    return  NotificationDetails(
      android: AndroidNotificationDetails(
        UberCloneConstants.NOTIFICATION_ID, 
        UberCloneConstants.NOTIFICATION_CHANNEL,
        channelDescription: "Notificação informativa",
        icon: icon,
        indeterminate: indeterminate?? false,
        progress: progress ?? 0 ,
        maxProgress: maxProgress  ?? 0,
        showProgress: showProgress ?? false ,
        importance: Importance.max,
        priority: Priority.max
        ),
        iOS: const DarwinNotificationDetails()
    );
  }

  
  @override
  Future<void> showNotification({ String? icon,int? progress,int? maxProgress,bool? showProgress,bool? indeterminate,
  @override
  int id = 0,required String title,required String body}) async {
    return _notificationPugin.show(id, title, body, _initializeDetailsNotification(
      icon,
      progress,
      maxProgress,
      showProgress,
      indeterminate,
      ));
  }
  

}
