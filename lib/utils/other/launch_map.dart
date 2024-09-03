import 'package:url_launcher/url_launcher.dart';

void launchMap({
  required double lat,
  required double long,
}) async {
  String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';

  // Encode the URL
  Uri uri = Uri.parse(url);

  // Launch the URL using the url_launcher package
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
