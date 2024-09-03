import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';

class GlobalVariablesUtils {
  static List<String> monthsNameList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  static int globalLastUpdateTime = 0;
  static Position? globalLastPosition;
  static Position? globalCurrentPosition;

  static late DatabaseReference globalSalesOrdersDb;
  static late DatabaseReference globalDriversDb;

  static StreamSubscription<Position>? globalLocationStreamSub;
  static Timer? globalUpdateTimer;

  static String getCurrentDate({required String locale}) {
    final formatter = DateFormat.yMMMMd(locale);
    return formatter.format(DateTime.now());
  }

  static bool hasEnabledWms = false;
}
