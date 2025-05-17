import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/services/notification_service/i_notification_service.dart';

class ServiceNotificationImpl implements INotificationService {
  final firebaseMassage = FirebaseMessaging.instance;
  final notificationPugin = FlutterLocalNotificationsPlugin();
   
   ServiceNotificationImpl(){}

  Future<void> initializedNotification()  async{
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
    notificationPugin.initialize(initisetting);
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
    return notificationPugin.show(id, title, body, _initializeDetailsNotification(
      icon,
      progress,
      maxProgress,
      showProgress,
      indeterminate,
      ));
  }
  

}
