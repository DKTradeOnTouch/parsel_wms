import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._internal();

  static LocationService instance = LocationService._internal();

  Future<bool> checkServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> isPermissionGranted() async {
    return _isPermissionGranted(await Geolocator.checkPermission());
  }

  Future<bool> requestPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    } else if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      return _isPermissionGranted(newPermission);
    }

    return true;
  }

  bool _isPermissionGranted(LocationPermission permission) =>
      permission != LocationPermission.denied &&
      permission != LocationPermission.deniedForever;
}
