import 'package:flutter/material.dart';
import 'package:uber_clone_flutter_udemy/src/utils/colors.dart' as utils;

class Snackbar {
  static void showSnackbar(
      BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    if (context == null) return;
    if (key == null) return;
    if (key.currentState == null) return;

    FocusScope.of(context).requestFocus(FocusNode());

    key.currentState?.removeCurrentSnackBar();
    key.currentState!.showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: utils.Colors.uberCloneColor,
        duration: const Duration(seconds: 3)));
  }
}
