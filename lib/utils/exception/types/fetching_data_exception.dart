part of parsel_exchange_exceptions;

/// Class to handle Exceptions Based on Fetching Data.
class FetchingDataException implements Exception {
  /// Constructor of Fetching Data Exceptions.
  FetchingDataException();
  final String _title = '''Fetching Data!''';
  final String _message = '''Fetching Data!''';

  /// getter of message.
  String getMessage() => _message;

  /// show snackbar.
  void showToast(BuildContext context) {}
}
