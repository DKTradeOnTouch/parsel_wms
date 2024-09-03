part of parsel_exchange_exceptions;

/// Class to handle PageNotFound Based Exceptions.
class PageNotFoundException implements Exception {
  /// Constructor of Server Based Exception.
  PageNotFoundException();

  final String _title = '''Page Not Found!''';
  final String _message = '''Requested Page is not found!''';

  /// getter of message.
  String getMessage() => _message;

  /// show snackbar.
  void showToast(BuildContext context) {
   
  }
}
