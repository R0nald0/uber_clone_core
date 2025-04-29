import 'package:flutter/widgets.dart';

class UberMessanger {
   final String? title;
   final String? body;
   final String? icon;
   final String? imgUrl;
   final DateTime? dateTime;

  UberMessanger({
    this.title,
    this.body,
    this.icon,
    this.imgUrl,
    this.dateTime,
  });

  factory UberMessanger.toUberMessanger(String? title,String? body,String? imageUrl,DateTime? dateTime,String? icon){
      return UberMessanger(
         title: title,
         body: body,
         imgUrl: imageUrl,
         dateTime: dateTime ?? DateTime.now(),
         icon: icon
        );
  }
    

  UberMessanger copyWith({
    ValueGetter<String?>? title,
    ValueGetter<String?>? body,
    ValueGetter<String?>? icon,
    ValueGetter<String?>? imgUrl,
    ValueGetter<DateTime?>? dateTime,
  }) {
    return UberMessanger(
      title: title != null ? title() : this.title,
      body: body != null ? body() : this.body,
      icon: icon != null ? icon() : this.icon,
      imgUrl: imgUrl != null ? imgUrl() : this.imgUrl,
      dateTime: dateTime != null ? dateTime() : this.dateTime,
    );
  }
}
