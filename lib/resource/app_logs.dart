import 'package:flutter/foundation.dart';

void appLogs(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
