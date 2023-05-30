import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    String? helperText,
    IconData? prefix,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primary,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primary,
          width: 2,
        ),
      ),
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: prefix != null
          ? Icon(
              prefix,
              color: AppTheme.primary,
            )
          : null,
    );
  }
}
