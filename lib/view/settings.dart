// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/services/auth/auth_gate.dart';
import 'package:talky/services/auth/auth_service.dart';
import 'package:talky/view/blocked_user.dart';
import '../themes/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService auth = AuthService();
  void deleteAccount(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await auth.deleteAccount();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account deleted successfully')));
                      // Navigate to login screen or home screen after deletion
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthGate()));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to delete account: $e')));
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: FadeInDown(
            delay: Duration(milliseconds: 300),
            child: Text(
              'S E T T I N G S',
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: FadeInDown(
              delay: Duration(milliseconds: 700),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  //dark mode switch
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.dark_mode),
                            SizedBox(width: 8),
                            Text(
                              "Dark Mode",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        CupertinoSwitch(
                          value:
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .isDarkMode,
                          onChanged: (value) =>
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(),
                        )
                      ],
                    ),
                  ),
                  //======blocked users list========
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.only(right: 25, left: 25),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off),
                            SizedBox(width: 8),
                            Text(
                              "Blocked Users",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlockedUser()));
                          },
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  //======delete account======
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Delete Account",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            deleteAccount(context, "");
                          },
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
