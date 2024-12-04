import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDialog {
  static void showAdaptiveDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    Map<Text, VoidCallback>? actions,
  }) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showIOSDialog(context, title: title, content: content, actions: actions);
    } else {
      showAndroidDialog(context,
          title: title, content: content, actions: actions);
    }
  }

  static void showAndroidDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    Map<Text, VoidCallback>? actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content,
          actions: actions?.entries
                  .map(
                    (entry) => TextButton(
                      onPressed: entry.value,
                      child: entry.key,
                    ),
                  )
                  .toList() ??
              [],
        );
      },
      useSafeArea: false,
    );
  }

  static void showIOSDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    Map<Text, VoidCallback>? actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: content,
          actions: actions?.entries
                  .map(
                    (entry) => CupertinoDialogAction(
                      onPressed: entry.value,
                      child: entry.key,
                    ),
                  )
                  .toList() ??
              [],
        );
      },
    );
  }
}
