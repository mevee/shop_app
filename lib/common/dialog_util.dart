import 'package:flutter/material.dart';

/// Shows a customizable alert dialog
/// 
/// Parameters:
/// - context: BuildContext
/// - title: Dialog title (String or Widget)
/// - message: Dialog content (String or Widget)
/// - primaryButtonText: Text for primary button (defaults to 'OK')
/// - secondaryButtonText: Text for secondary button (optional)
/// - onPrimaryPressed: Callback for primary button
/// - onSecondaryPressed: Callback for secondary button
/// - barrierDismissible: Whether dialog can be dismissed by tapping outside (default true)
/// - isDestructiveAction: Whether primary button should be styled as destructive (default false)
Future<void> showCustomDialog({
  required BuildContext context,
  required dynamic title,
  required dynamic message,
  String primaryButtonText = 'OK',
  String? secondaryButtonText,
  VoidCallback? onPrimaryPressed,
  VoidCallback? onSecondaryPressed,
  bool barrierDismissible = true,
  bool isDestructiveAction = false,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title is String ? Text(title) : title as Widget,
        content: message is String ? Text(message) : message as Widget,
        actions: <Widget>[
          if (secondaryButtonText != null)
            TextButton(
              child: Text(secondaryButtonText),
              onPressed: () {
                Navigator.of(context).pop();
                if (onSecondaryPressed != null) onSecondaryPressed();
              },
            ),
          TextButton(
            child: Text(
              primaryButtonText,
              style: isDestructiveAction
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (onPrimaryPressed != null) onPrimaryPressed();
            },
          ),
        ],
      );
    },
  );
}