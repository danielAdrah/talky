// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../view/profile_view.dart';
import '../view/settings.dart';

class CustomeDrawer extends StatelessWidget {
  const CustomeDrawer({super.key});
  logOut() {
    final _auth = AuthService();
    _auth.singOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image(
                    image: AssetImage("assets/img/speech-bubble (1).png"),
                    width: 220,
                    height: 220,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: ListTile(
                  title: Text(
                    "H O M E",
                  ),
                  leading: Icon(
                    Icons.home,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: ListTile(
                  title: Text(
                    "P R O F I L E",
                  ),
                  leading: Icon(
                    Icons.person_4_rounded,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileView()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                  ),
                  leading: Icon(
                    Icons.settings,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
              ),
              leading: Icon(
                Icons.logout,
                size: 25,
              ),
              onTap: () => logOut(),
            ),
          )
        ],
      ),
    );
  }
}
