import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDialog {
  static void showAdaptiveDialog(BuildContext context, Widget dialog) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showIOSDialog(context, dialog);
    } else {
      showAndroidDialog(context, dialog);
    }
  }

  static void showAndroidDialog(BuildContext context, Widget dialog) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: dialog,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        );
      },
      useSafeArea: false,
    );
  }

  static void showIOSDialog(BuildContext context, Widget dialog) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: dialog,
        );
      },
    );
  }
}
