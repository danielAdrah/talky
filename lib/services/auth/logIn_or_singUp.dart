import 'package:flutter/material.dart';

import '../../view/login.dart';
import '../../view/sing_up.dart';

class LogInOrSingUp extends StatefulWidget {
  const LogInOrSingUp({super.key});

  @override
  State<LogInOrSingUp> createState() => _LogInOrSingUpState();
}

class _LogInOrSingUpState extends State<LogInOrSingUp> {
  //this page initailly will show the login page
  bool isLogIn = true;
  void togglePages(){
    setState(() {
      isLogIn = !isLogIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLogIn){
      return LogIn(onPressed:togglePages );
    } else{
      return SingUp(onPressed: togglePages);
    }
  }
}