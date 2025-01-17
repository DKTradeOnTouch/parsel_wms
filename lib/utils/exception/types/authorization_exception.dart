part of parsel_exchange_exceptions;

/// Class to handle Authorization Based Exception.
class AuthorizationException implements Exception {
  /// Constructor of Authorization Based Exception.
  AuthorizationException();
  final String _title = '''Not Authorized!''';
  final String _message =
      '''You have insufficient Permissions for this request.\nPlease request with proper permission!''';

  /// getter of message.
  String getMessage() => _message;

  /// show snackbar.
  void showToast(BuildContext context) {}
}
