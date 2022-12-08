import 'package:flutter/material.dart';
import 'package:uber_clone/src/utils/colors.dart' as utils;

class Snackbar {
  static void showSnackbar(
      BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    // ignore: unnecessary_null_comparison
    if (context == null) return;
    // ignore: unnecessary_null_comparison
    if (key == null) return;
    if (key.currentState == null) return;

    FocusScope.of(context).requestFocus(FocusNode());

    //key.currentState?.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: utils.Colors.uberCloneColor,
        duration: const Duration(seconds: 3)));
  }
}
