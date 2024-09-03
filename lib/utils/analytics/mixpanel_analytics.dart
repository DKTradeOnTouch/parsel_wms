import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:parsel_flutter/resource/app_logs.dart';

class MixpanelManager {
  static late Mixpanel mixpanel;

  static Future<Mixpanel> init() async {
    mixpanel = await Mixpanel.init("dfdaa9358b7ff9362cae5d17dfea34cf",
        optOutTrackingDefault: false, trackAutomaticEvents: true);
    mixpanel.setLoggingEnabled(true);
    return mixpanel;
  }

  static void trackEvent(
      {Map<String, dynamic>? properties, required String eventName}) {
    // if (kDebugMode) {
    //   return;
    // }
    try {
      mixpanel.track(eventName, properties: properties);
    } catch (e) {
      appLogs('catch error while track mixpanel event --> $e');
    }
  }
}
