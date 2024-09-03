

/// all the validations are stored in this class.
class Validators {
  /// email validation.
  static bool validateEmptyField({required String value}) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateEmail({required String value}) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return false;
    }
    return true;
  }
}
