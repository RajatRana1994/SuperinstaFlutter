import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shows an iOS-style confirmation dialog.
///
/// Returns `true` if the user tapped **Yes**, `false` for **No**,
/// and `null` if they dismissed the sheet by tapping outside.
Future<bool?> showCupertinoConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  String yesLabel = 'Yes',
  String noLabel  = 'No',
}) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(description),
      ),
      actions: [
        // No / Cancel
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(noLabel),
        ),
        // Yes / Confirm
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesLabel),
        ),
      ],
    ),
  );
}
