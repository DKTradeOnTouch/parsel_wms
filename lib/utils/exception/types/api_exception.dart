part of parsel_exchange_exceptions;

/// Class to handle Unknown or All API Exceptions.
class APIException implements Exception {
  /// Constructor of API Exceptions.
  APIException({required this.message});

  final String _title = '''API Exception!''';

  /// message to show with this exception.
  final String message;

  /// getter of message.
  String getMessage() => message;

  /// show snackbar.
  void showToast(BuildContext context) {}
}
