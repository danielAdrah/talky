import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:talky/components/custome_text_field.dart';
import 'package:talky/components/primary_button.dart';

import '../services/auth/auth_service.dart';

class SingUp extends StatefulWidget {
  SingUp({super.key, required this.onPressed});
  void Function()? onPressed;

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final TextEditingController mailCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController cpwCont = TextEditingController();
 
  bool isVisible = false;
  bool isVisible2 = false;
  bool isLoading = false;
  signOut(BuildContext context) {
    final auth = AuthService();

    if (pwCont.text == cpwCont.text) {
      setState(() {
        isLoading = true;
      });
      try {
        auth.signUp(mailCont.text, pwCont.text);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(e.toString().substring(0, 20)),
              );
            });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text("password doesn't match"),
      //       );
      //     });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password does not match ')));
    }
  }

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
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    "Let's create an account for you",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                ),
                SizedBox(height: 25),
                FadeInDown(
                  delay: Duration(milliseconds: 100),
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
                  delay: Duration(milliseconds: 200),
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
                  delay: Duration(milliseconds: 300),
                  child: CustomeTextField(
                      type: TextInputType.name,
                      onTap: () {
                        setState(() {
                          isVisible2 = !isVisible2;
                        });
                      },
                      text: "Confirm Password",
                      icon: Icons.lock,
                      secure: isVisible2,
                      suffixScon:
                          isVisible2 ? Icons.visibility_off : Icons.visibility,
                      controller: cpwCont),
                ),
                SizedBox(height: 25),
                isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : FadeInDown(
                        delay: Duration(milliseconds: 400),
                        child: PrimaryButton(
                          onTap: () => signOut(context),
                          text: "SingUp",
                        ),
                      ),
                FadeInDown(
                  delay: Duration(milliseconds: 450),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      TextButton(
                          onPressed: widget.onPressed,
                          child: Text(
                            "LogIn now",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          )),
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
