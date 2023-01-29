import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade400),
);

final inputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
  border: inputBorder,
  focusedBorder: inputBorder,
  enabledBorder: inputBorder,
);

class OTPFields extends StatefulWidget {
  final TextEditingController pin1;
  final TextEditingController pin2;
  final TextEditingController pin3;
  final TextEditingController pin4;
  final TextEditingController pin5;
  final TextEditingController pin6;

  const OTPFields({
    Key? key,
    required this.pin1,
    required this.pin2,
    required this.pin3,
    required this.pin4,
    required this.pin5,
    required this.pin6,
  }) : super(key: key);

  @override
  State<OTPFields> createState() {
    return _OTPFieldsState();
  }
}

class _OTPFieldsState extends State<OTPFields> {
  FocusNode? pin1FN;
  FocusNode? pin2FN;
  FocusNode? pin3FN;
  FocusNode? pin4FN;
  FocusNode? pin5FN;
  FocusNode? pin6FN;

  final pinStyle = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    pin1FN = FocusNode();
    pin2FN = FocusNode();
    pin3FN = FocusNode();
    pin4FN = FocusNode();
    pin5FN = FocusNode();
    pin6FN = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FN?.dispose();
    pin2FN?.dispose();
    pin3FN?.dispose();
    pin4FN?.dispose();
    pin5FN?.dispose();
    pin6FN?.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin1,
                  autofocus: true,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) {
                    nextField(value, pin2FN!);
                  },
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin2,
                  focusNode: pin2FN,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) => nextField(value, pin3FN!),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin3,
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  onChanged: (value) => nextField(value, pin4FN!),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin4,
                  focusNode: pin4FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin5FN!),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin5,
                  focusNode: pin5FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) => nextField(value, pin6FN!),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  controller: widget.pin6,
                  focusNode: pin6FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FN!.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
