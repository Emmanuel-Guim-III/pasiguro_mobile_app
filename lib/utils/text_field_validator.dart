class TextFieldValidator {
  static String? validate(String? value) {
    if (value!.isEmpty) {
      return ErrorMessages.emptyField;
    }

    return null;
  }
}

class ErrorMessages {
  static String none = '';
  static String emptyField = 'Do not leave an empty field.';
}
