import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showCommonSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: .5),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
