// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:talky/components/user_tile.dart';
import 'package:talky/services/chat/chat_service.dart';
import 'package:talky/view/chat_view.dart';

import '../services/auth/auth_service.dart';
import '../components/custome_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final chatService = ChatService();
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: FadeInDown(
            delay: Duration(milliseconds: 500),
            curve: Curves.decelerate,
            child: Text(
              'U S E R S',
            ),
          ),
        ),
        drawer: CustomeDrawer(),
        body: SafeArea(
            child: FadeInDown(
                delay: Duration(milliseconds: 600),
                curve: Curves.decelerate,
                child: userBuilder())),
      ),
    );
  }

  Widget userBuilder() {
    return StreamBuilder(
        stream: chatService.getUsersExcludeBlocked(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: ZoomIn(
                delay: Duration(milliseconds: 300),
                child: Text(
                  "There are no users yet!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => userListItem(userData, context))
                .toList(),
          );
        });
  }

  //===========
  Widget userListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != authService.getCurrent()!.email) {
      //this condition is to display all the users in the app
      //without the account im logging in
      return UserTile(
          onTap: () {
            // this will take you to the chat page with the user
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  receiverID: userData["uid"],
                  recieverEmail: userData["email"],
                ),
              ),
            );
          },
          title: userData["email"]);
    } else {
      return Container();
    }
  }
}
