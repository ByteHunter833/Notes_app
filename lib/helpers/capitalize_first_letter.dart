import 'package:flutter/services.dart';

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String firstLetter = newValue.text.substring(0, 1).toUpperCase();
    String rest = newValue.text.substring(1).toLowerCase();

    return TextEditingValue(
      text: firstLetter + rest,
      selection: TextSelection.collapsed(offset: newValue.selection.end),
    );
  }
}
