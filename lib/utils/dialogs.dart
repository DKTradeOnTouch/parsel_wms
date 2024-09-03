import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String positiveButtonLabel,
  String negativeButtonLabel = "Cancel",
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(positiveButtonLabel),
            onPressed: () {
              Navigator.of(dialogContext).pop(true); // Dismiss alert dialog
            },
          ),
          TextButton(
            child: Text(negativeButtonLabel),
            onPressed: () {
              Navigator.of(dialogContext).pop(false); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}
