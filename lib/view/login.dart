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
  bool isLoading = false;

  void logIn(BuildContext context) async {
    // auth service
    final authService = AuthService();
    setState(() {
      isLoading = true;
    });

    //try logIn
    try {
      await authService.signInWithEmailPassword(mailCont.text, pwCont.text);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("errorrrrrrrr${e.toString()}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //==============
  // void logIn(BuildContext context) async {
  //   // auth service
  //   final authService = AuthService();
  //   setState(() {
  //     isLoading = true;
  //   });

  //   //try logIn
  //   try {
  //     await authService.signInWithEmailPassword(mailCont.text, pwCont.text);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     String errorMessage;

  //     switch (e.code) {
  //       case "invalid-email":
  //         errorMessage = "Invalid email address";
  //         break;
  //       case "wrong-password":
  //         errorMessage = "Wrong password";
  //         break;
  //       case "user-not-found":
  //         errorMessage = "User not found";
  //         break;
  //       case "network-request-failed":
  //         errorMessage = "No internet connection";
  //         break;
  //       case "too-many-requests":
  //         errorMessage = "Too many login attempts. Please try again later.";
  //         break;
  //       default:
  //         errorMessage = "An unexpected error occurred";
  //         break;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage)),
  //     );
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print('Exception type: ${e.runtimeType}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("An unexpected error occurred")),
  //     );
  //   }
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
                isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : FadeInDown(
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
