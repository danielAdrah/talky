// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talky/components/custome_text_field.dart';
import 'package:talky/components/primary_button.dart';

import '../services/auth/auth_service.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key, required this.onPressed});
  void Function()? onPressed;

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController mailCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isVisible = false;
  void logIn(BuildContext context) async {
    //auth service
    final authService = AuthService();

    //try logIn
    try {
      await authService.signInWithEmailPassword(mailCont.text, pwCont.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(e.toString().substring(0, 20)),
            );
          });
    }
  }
  // Future<void> signInWithPassword() async {
  //   try {
  //     await auth.signInWithEmailAndPassword(
  //         email: "test@gmail.com", password: "112233");

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //   if (e.code == 'network-request-failed') {
  //     print('Network request failed');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Please check your internet connection')));
  //   } else {
  //     print('Firebase Authentication error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(e.message ?? 'An error occurred')));
  //   }
  // } catch (e) {
  //   print('Unexpected error: $e');
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An unexpected error occurred')));
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZoomIn(
                  delay: Duration(milliseconds: 600),
                  child: Image(
                      image: AssetImage("assets/img/speech-bubble (1).png"),
                      height: 130,
                      width: 130),
                ),
                SizedBox(height: 50),
                FadeInDown(
                  delay: Duration(milliseconds: 100),
                  child: Text(
                    "Welcome Back Good To See You Again",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                ),
                SizedBox(height: 25),
                FadeInDown(
                  delay: Duration(milliseconds: 200),
                  child: CustomeTextField(
                    type: TextInputType.emailAddress,
                    text: "E-mail",
                    icon: Icons.mail,
                    secure: false,
                    controller: mailCont,
                  ),
                ),
                SizedBox(height: 25),
                FadeInDown(
                  delay: Duration(milliseconds: 300),
                  child: CustomeTextField(
                    type: TextInputType.name,
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    text: "Password",
                    icon: Icons.lock,
                    secure: isVisible,
                    suffixScon:
                        isVisible ? Icons.visibility_off : Icons.visibility,
                    controller: pwCont,
                  ),
                ),
                SizedBox(height: 25),
                FadeInDown(
                  delay: Duration(milliseconds: 400),
                  child: PrimaryButton(
                    onTap: () => logIn(context),
                    text: "LogIn",
                  ),
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      TextButton(
                        onPressed: widget.onPressed,
                        child: Text(
                          "Register now",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
