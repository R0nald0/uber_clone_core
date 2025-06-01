import 'package:intl/intl.dart';

extension UberCloneDateFormat on DateTime{
 
String uberFormatDate(String? locale) {
  // Define o formato: dia (d), mês abreviado (MMM), hora e minuto (HH:mm)
  final DateFormat formatter = DateFormat("d 'de' MMM/yy - HH:mm",locale);
  return formatter.format(this);
}

} 