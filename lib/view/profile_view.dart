// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unused_field

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talky/services/auth/auth_service.dart';
import 'package:talky/services/chat/chat_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService auth = AuthService();
  final ChatService chat = ChatService();
  Map<String, dynamic> _userInfo = {};
  String _error = "";

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await chat.getUserInfo();
      print('Fetched user info: $userInfo');
      setState(() {
        _userInfo = userInfo;
      });
    } catch (e) {
      print('Error fetching user info: $e');
      setState(() {
        _userInfo = {};
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          child: Text('P R O F I L E'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/img/u1.png"),
                      radius: 80,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          //method to select an image
                        },
                        child: CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _userInfo.isNotEmpty
                    ? buildInfoRow("Email", _userInfo['email'] ?? "ll")
                    : Text(_error),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
