// ignore_for_file: no_leading_underscores_for_local_identifiers

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
          title: Text(
            'Home',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        drawer: CustomeDrawer(),
        body: SafeArea(child: userBuilder()),
      ),
    );
  }

  Widget userBuilder() {
    return StreamBuilder(
        stream: chatService.getUserStream(),
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
