import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.onTap, required this.title});
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        padding: EdgeInsets.all(25),
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 30,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            SizedBox(width: 10),
            Text(title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }
}
