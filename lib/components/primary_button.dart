import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
   PrimaryButton({super.key, required this.text,required this.onTap});
  final String text;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(13),
        ),
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.all(30),
        child:Center(child: Text(text,style: TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w500),),),
      ),
    );
  }
}