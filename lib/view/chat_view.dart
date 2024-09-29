// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/components/chat_bubble.dart';
import 'package:talky/services/auth/auth_service.dart';
import 'package:talky/themes/theme_provider.dart';

import '../components/custome_text_field.dart';
import '../services/chat/chat_service.dart';

class ChatView extends StatefulWidget {
  final String recieverEmail;
  final String receiverID;
  ChatView({super.key, required this.recieverEmail, required this.receiverID});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthService auth = AuthService();

  final ChatService chat = ChatService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    //this for scrolling down the messages
    Future.delayed(
      Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    messageController.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send a message
  void sendMessage() async {
    //make sure that there is something in the message
    if (messageController.text.isNotEmpty) {
      await chat.sendMessage(widget.receiverID, messageController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   centerTitle: true,
        //   title: Text(
        //     widget.recieverEmail,
        //     style:
        //         TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        //   ),
        // ),
        body: Container(
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(isDarkMode
                      ? "assets/img/dark.jpg"
                      : "assets/img/light.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  SizedBox(width: 80),
                  Text(
                    widget.recieverEmail,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: buildMessageList(),
              ),
              // buildUserInput(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomeTextField(
                        controller: messageController,
                        myFocusNode: myFocusNode,
                        secure: false,
                        text: "Type a message",
                        type: TextInputType.name,
                        icon: Icons.emoji_emotions,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.greenAccent
                              : Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: IconButton(
                                onPressed: () {
                                  sendMessage();
                                  messageController.clear();
                                  scrollDown();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ))))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //=========list of the messages=============
  Widget buildMessageList() {
    String senderID = auth.getCurrent()!.uid;
    return StreamBuilder(
        stream: chat.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // if has errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            );
          }

          //if it is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No messages yet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }

          //return a list of messages
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //=========message item============
  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == auth.getCurrent()!.uid;

    //timestamp for the message
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String messageDate = dateTime.toString().substring(11, 16);

    //the status of the message
    bool isRead = data['isRead'] ?? false;

    print("Message ID: ${doc.id}, Is Read: $isRead");

    //align the message depending on the sender is the current user
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: ChatBubble(
          message: data["message"],
          messageTime: messageDate,
          isCurrentUser: isCurrentUser,
          messageId: doc.id,
          userId: data['senderID'],
          isRead: isRead,
        ));
  }

  //========user input============
  Widget buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomeTextField(
              controller: messageController,
              secure: false,
              text: "Type a message",
              type: TextInputType.name,
              icon: Icons.emoji_emotions,
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: IconButton(
                      onPressed: () {
                        sendMessage();
                        messageController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ))))
        ],
      ),
    );
  }
}
