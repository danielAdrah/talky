import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  CustomeTextField({
    super.key,
    required this.text,
    required this.icon,
    this.suffixScon,
    required this.secure,
    required this.controller,
    this.onTap,
    this.myFocusNode,
    required this.type,
  });
  final String text;
  final IconData icon;
  final IconData? suffixScon;
  final bool secure;
  void Function()? onTap;
  final TextEditingController controller;
  final TextInputType type;
  final FocusNode? myFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        focusNode: myFocusNode,
        keyboardType: type,
        obscureText: secure,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: text,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 16),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(
                  suffixScon,
                  color: Theme.of(context).colorScheme.primary,
                ))),
      ),
    );
  }
}
