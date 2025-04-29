import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/model/uber_messager.dart';
import 'package:uber_clone_core/src/services/notification_service/i_notification_service.dart';

class ServiceNotificationImpl implements INotificationService {
  final firebaseMassage = FirebaseMessaging.instance;
  final notificationPugin = FlutterLocalNotificationsPlugin();

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
        priority: Priority.high
        ),
        iOS: const DarwinNotificationDetails()
    );

  }


  @override
  Future<void> requestPermission() async {
    final notificationSetting = await firebaseMassage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    notificationSetting.authorizationStatus.name;
  }

  @override
  Future<void> showNotification({ String? icon,int? progress,int? maxProgress,bool? showProgress,bool? indeterminate,
  int id = 0,required String title,required String body}) async {
    return notificationPugin.show(id, title, body, _initializeDetailsNotification(
      icon,
      progress,
      maxProgress,
      showProgress,
      indeterminate
      ));
  }

  @override
  Stream<UberMessanger> getNotificationFistPlane() async* {
    yield*  FirebaseMessaging.onMessage.asyncMap(
      (messanger) => UberMessanger.toUberMessanger(
      messanger.notification?.title, 
      messanger.notification?.body, 
      messanger.notification?.android?.imageUrl, 
      messanger.sentTime, 
      messanger.notification?.android?.smallIcon
      ) );
  }

  @override
  Stream<String> onTokenRefresh() async* {
   yield* firebaseMassage.onTokenRefresh;
  }

  @override
  Future<String?> getTokenDevice() =>firebaseMassage.getToken();

}
