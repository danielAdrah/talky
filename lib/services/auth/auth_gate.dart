import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talky/services/auth/logIn_or_singUp.dart';

import '../../view/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //this stream is going to listen to all the changes
      //in the auth state(weather the user is logged in or not)
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if is logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          //if not logged in
          else {
            return LogInOrSingUp();
          }
        },
      ),
    );
  }
}
