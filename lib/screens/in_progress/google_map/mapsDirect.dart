import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double latitute, double longitute) async {
    String googleMapUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitute,$longitute&travelmode=driving";

    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not open the map';
    }
  }
}
