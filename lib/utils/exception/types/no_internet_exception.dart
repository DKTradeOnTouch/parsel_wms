part of parsel_exchange_exceptions;

/// Class to handle Exceptions when Internet is not connected.
class NoInternetException implements Exception {
  /// Constructor of NoInternet Exceptions.
  NoInternetException();
  final String _title = '''No Internet!''';
  final String _message =
      '''You are not Connected to the internet\nPlease turn your internet connection on and try again.''';

  /// getter of message.
  String getMessage() => _message;

  /// show snackbar.
  void showToast(BuildContext context) {}

  ///Network Widget To Display Network Error
  void showNoNetworkWidget(
      {required BuildContext context,
      required VoidCallback onCancelTap,
      required VoidCallback onRetryTap}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(_title),
            content: Text('No Internet',
                style: FontUtilities.h14(fontColor: ColorUtils.blackColor)),
            actions: [
              // ignore: deprecated_member_use
              ElevatedButton(
                  onPressed: onCancelTap, child: const Text('Cancel')),
              //    ignore: deprecated_member_use
              ElevatedButton(onPressed: onRetryTap, child: const Text('Retry'))
            ],
          );
        });
  }
}
