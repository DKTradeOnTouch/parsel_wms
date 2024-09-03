import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:flutter/services.dart';
import 'package:parsel_flutter/utils/utils.dart';

class ConnectivityHandler {
  static final Connectivity _connectivity = Connectivity();
  static List<ConnectivityResult> connectivityResult = [
    ConnectivityResult.none
  ];

  Future initConnectivity() async {
    List<ConnectivityResult> result = [];
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return;
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    print("_updateConnectionStatus ==> $result");
    connectivityResult = result;
    EventBusUtils.eventBus.fire(ConnectivityChangeStateEvent(result));
  }
}

class ConnectivityChangeStateEvent extends AppEvent {
  final List<ConnectivityResult> connectivityResult;

  const ConnectivityChangeStateEvent(this.connectivityResult);

  @override
  List<Object?> get props => [connectivityResult];
}
