import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../models/money.dart';

Box<Money> hiveBox = Hive.box<Money>('moneyBox');

String year = Jalali.now().year.toString();
String month = Jalali.now().month.toString().length == 1
    ? '0${Jalali.now().month.toString()}'
    : Jalali.now().month.toString();
String day = Jalali.now().day.toString().length == 1
    ? '0${Jalali.now().day.toString()}'
    : Jalali.now().day.toString();

class Calculate {
  static String today() {
    return '$year/$month/$day';
  }

  static double pToday() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date == today() && element.isReceived == false) {
        result += double.parse(element.price);
      }
    }
    return result;
  }

  static double dToday() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date == today() && element.isReceived == true) {
        result += double.parse(element.price);
      }
    }
    return result;
  }

  static double pMonth() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date.substring(5, 7) == month &&
          element.isReceived == false) {
        result += double.parse(element.price);
      }
    }
    return result;
  }

  static double dMonth() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date.substring(5, 7) == month && element.isReceived == true) {
        result += double.parse(element.price);
      }
    }
    return result;
  }

  static double pYear() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date.substring(0, 4) == year && element.isReceived == false) {
        result += double.parse(element.price);
      }
    }
    return result;
  }

  static double dYear() {
    double result = 0;
    for (var element in hiveBox.values) {
      if (element.date.substring(0, 4) == year && element.isReceived == true) {
        result += double.parse(element.price);
      }
    }
    return result;
  }
}
