import 'package:flutter/material.dart';
import 'package:shop_app/data/network/app_colors.dart';

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

void showInputDialog({
  required BuildContext context,
  required Function(String) onSubmit,
  String title = 'Input Required',
  String submitLabel = 'OK',
  String placeholder = 'Enter text here',
  String errorText = 'This field is required',
}) {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: true, // Prevent closing by tapping outside
  // ,
    builder: (BuildContext context) {
      return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      // contentPadding: EdgeInsets.all(0),
    
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                softWrap: true,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return errorText;
                  }
                  return null;
                },
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                onSubmit(controller.text);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.cherryRed,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              submitLabel,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(
          right: 16,
          bottom: 16,
        ),
      );
    },
  );
}