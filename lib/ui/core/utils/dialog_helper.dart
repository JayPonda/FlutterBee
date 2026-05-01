import 'package:flutter/cupertino.dart';

class DialogHelper {
  static Future<bool> showCallConfirmation(BuildContext context, String name) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Confirm Call'),
        content: Text('Are you sure you want to call $name?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
