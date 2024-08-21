import 'package:fluttertoast/fluttertoast.dart';

class ToastMessageService {
  static void show(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
    );
  }
}
