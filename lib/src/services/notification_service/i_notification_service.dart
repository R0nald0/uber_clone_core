
abstract interface class INotificationService {
   
   Future<void> showNotification( {String? icon ,int? progress,int? maxProgress,bool? showProgress,bool? indeterminate,
   int id = 0,required String title,required String body}) ;

  

}