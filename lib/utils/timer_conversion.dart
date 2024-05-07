import 'package:intl/intl.dart';

String convertTime(DateTime dateTime) {
  String istStr = DateFormat('HH:mm:ss').format(dateTime);
  print("India Standard Time (IST): $istStr");
  return istStr;
}
