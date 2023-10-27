import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Limit the length to 63 characters
    if (newValue.text.length > 63) {
      return oldValue;
    }

    // Enforce that the text starts and ends with a lowercase letter or a digit
    if (!RegExp(r'^[a-z0-9]?.*[a-z0-9]?$').hasMatch(newValue.text)) {
      return oldValue;
    }

    // Enforce valid characters in between
    if (!RegExp(r'^[a-z0-9._-]*$').hasMatch(newValue.text)) {
      return oldValue;
    }

    // Prevent two consecutive dots
    if (newValue.text.contains('..')) {
      return oldValue;
    }

    // Enforce that the text is not a valid IP address
    final RegExp ipRegex = RegExp(
        r'^((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$');
    if (ipRegex.hasMatch(newValue.text)) {
      return oldValue;
    }

    // If all conditions are met, allow the new value
    return newValue;
  }
}
