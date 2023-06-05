import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.hintText,
    required this.icon,
    hasFocus = false,
    required this.focusNode,
    this.controller,
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final bool hasFocus = false;
  final FocusNode focusNode;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            focusColor: Colors.black,
            prefixIconColor: Colors.black,
            suffixIconColor: Colors.black,
            suffixIcon: IconButton(
              onPressed: () {
                controller!.text = '';
                if (onClear != null) {
                  onClear!();
                }
              },
              icon: const Icon(
                Icons.clear,
                size: 20,
              ),
            ),
            hintText: hintText,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            hintStyle: const TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            prefixIcon: Icon(icon)),
      ),
    );
  }
}
