import 'package:flutter/material.dart';
import 'package:talky/components/user_tile.dart';
import 'package:talky/services/auth/auth_service.dart';

import '../services/chat/chat_service.dart';

class BlockedUser extends StatelessWidget {
  BlockedUser({super.key});

  final AuthService auth = AuthService();
  final ChatService chat = ChatService();

  void unblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Unnlock User"),
              content: Text("Are you sure tou want to unblock this user?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      chat.unblockUser(userId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("User unblocked"),
                      ));
                    },
                    child: Text("Unblock")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    String userId = auth.getCurrent()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOCKED USERS'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chat.getBlockedUsers(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            //   if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return Center(child: Text('No blocked users'));
            // }
            final blockUsers = snapshot.data ?? [];

            //if no users
            if (blockUsers.isEmpty) {
              return Center(
                child: Text("No blocked users"),
              );
            }
            return ListView.builder(
                itemCount: blockUsers.length,
                itemBuilder: (context, index) {
                  final user = blockUsers[index];
                  return UserTile(
                      onTap: () => unblockBox(context, user['uid']),
                      title: user['email']);
                });
          }),
    );
  }
}
