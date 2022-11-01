import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  ButtonApp(
      {super.key,
      this.color,
      required this.text,
      required this.icon,
      required this.onPressed});
  Color? color = Colors.black;
  String text;
  IconData icon = Icons.arrow_forward_ios;
  Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            backgroundColor: color,
          ),
          onPressed: () {
            onPressed();
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 50.0,
                  child: CircleAvatar(
                    radius: 15.0,
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
