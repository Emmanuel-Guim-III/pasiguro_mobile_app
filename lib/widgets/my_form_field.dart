import 'package:flutter/material.dart';

typedef ValidatorCallback = String? Function(String?);
typedef TappedCallback = void Function();

class MyFormField {
  static TextFormField textField({
    required String value,
    required String label,
    required ValueChanged onChanged,
    ValidatorCallback? onValidate,
    TappedCallback? onTapped,
  }) {
    return TextFormField(
      initialValue: value,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: onValidate,
      onChanged: onChanged,
      onTap: onTapped,
    );
  }

  static TextFormField numberField({
    required String value,
    required String label,
    required ValueChanged onChanged,
    ValidatorCallback? onValidate,
    TappedCallback? onTapped,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      validator: onValidate,
      onChanged: onChanged,
      onTap: onTapped,
    );
  }

  static TextFormField priceField({
    required String value,
    required String label,
    required ValueChanged onChanged,
    ValidatorCallback? onValidate,
    TappedCallback? onTapped,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        suffixText: 'PHP',
      ),
      keyboardType: TextInputType.number,
      validator: onValidate,
      onChanged: onChanged,
      onTap: onTapped,
    );
  }
}
