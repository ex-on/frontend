import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumFormatter extends TextInputFormatter {
  final List<String> masks;
  final String separator;

  PhoneNumFormatter({required this.masks, required this.separator});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;
    String? _separator;
    List<String>? _masks;
    String? _prevMask;
    _separator = (separator.isNotEmpty) ? separator : null;
    if (masks.isNotEmpty) {
      _masks = masks;
      _masks.sort((l, r) => l.length.compareTo(r.length));
      _prevMask = masks[0];
    }

    if (newText.isEmpty ||
        newText.length < oldText.length ||
        _masks == null ||
        _separator == null) {
      return newValue;
    }

    final pasted = (newText.length - oldText.length).abs() > 1;
    final mask = _masks.firstWhere((value) {
      final maskValue = pasted ? value.replaceAll(_separator!, '') : value;
      return newText.length <= maskValue.length;
    }, orElse: () => '');

    if (mask == '') {
      return oldValue;
    }

    final needReset =
        (_prevMask != mask || newText.length - oldText.length > 1);
    _prevMask = mask;

    if (needReset) {
      final text = newText.replaceAll(_separator, '');
      String resetValue = '';
      int sep = 0;

      for (int i = 0; i < text.length; i++) {
        if (mask[i + sep] == _separator) {
          resetValue += _separator;
          ++sep;
        }
        resetValue += text[i];
      }

      return TextEditingValue(
          text: resetValue,
          selection: TextSelection.collapsed(
            offset: resetValue.length,
          ));
    }

    if (newText.length < mask.length &&
        mask[newText.length - 1] == _separator) {
      final text =
          '$oldText$_separator${newText.substring(newText.length - 1)}';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(
          offset: text.length,
        ),
      );
    }

    return newValue;
  }
}
