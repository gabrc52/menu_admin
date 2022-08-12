import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

void showAlertDialog(String content, BuildContext context, bool mounted) {
  if (mounted) {
    showDialog(
      context: context,
      builder: (_) => WebViewAware(
        child: AlertDialog(
          content: Text(content),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  } else {
    debugPrint(content);
  }
}
