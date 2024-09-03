part of parsel_exchange_exceptions;

/// Class to handle Server Based Exceptions.
class ServerException implements Exception {
  /// Constructor of Server Based Exception.
  ServerException();

  final String _title = '''Server Exception!''';
  final String _message =
      '''Please Check After Some time.\nServer is not up!''';

  /// getter of message.
  String getMessage() => _message;

  /// show snackbar.
  void showToast(BuildContext context) {}
}
