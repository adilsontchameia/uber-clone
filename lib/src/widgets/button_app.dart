import 'package:flutter/material.dart';
import 'package:uber_clone/src/utils/colors.dart' as utils;

class ButtonApp extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final IconData icon;
  final Function onPressed;

  const ButtonApp({
    super.key,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      // color: color,
      //   textColor: textColor,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  icon,
                  color: utils.Colors.uberCloneColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
