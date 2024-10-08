// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talky/model/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  

  //GET ALL THE USERS
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // ALL THE USERS WITHOUT THE BLOCKED
  Stream<List<Map<String, dynamic>>> getUsersExcludeBlocked() {
    final currentUser = auth.currentUser;
    return firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get all the blocked users id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all the users
      final usersSnapshot = await firestore
          .collection('Users')
          .get(GetOptions(source: Source.server));

      //this will display all the user without me(current user) and the blocked users
      return usersSnapshot.docs
          .where((doc) =>
              doc.exists &&
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id) &&
              doc.data()['uid'] != null && // Ensure UID exists
              doc.data()['email'] != null) // Ensure email exists
          .map((doc) => doc.data())
          .toList();
      // usersSnapshot.docs
      //     .where((doc) =>
      //         doc.data()['email'] != currentUser.email &&
      //         !blockedUserIds.contains(doc.id))
      //     .map((doc) => doc.data())
      //     .toList();
    });
  }

//GET USER INFO
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;
        print('Attempting to fetch info for user with UID: $uid');
        final doc = await firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          print('User document found');
          return doc.data() as Map<String, dynamic>;
        } else {
          throw Exception('User document not found for UID: $uid');
        }
      } else {
        throw Exception('No current user logged in');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      rethrow; // Re-throw the exception so it can be caught by the caller
    }
  }

  //SEND A MESSAGE
  Future<void> sendMessage(String receiverID, message) async {
    //get the cureent user info
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now(); //the time the message is send
    //create new message
    MessageModel newMessage = MessageModel(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        isRead: false,
        timestamp: timestamp);

    print("after init");

    //create chap room to store the messages
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    print("Generated chatRoomID: $chatRoomID");

    //add the new nessage to the database

    await firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());


     await markMessageAsRead(chatRoomID, newMessage.message, currentUserId);
  }

  //GET THE MESSAGE
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //create a chat room for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //REPORT USERS
  Future<void> reportUser(String messageId, String userID) async {
    final currentUser = auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await firestore.collection('Reports').add(report);
  }

  //BLOCK USER
  Future<void> blockUser(String userId) async {
    final currentUser = auth.currentUser;
    await firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});

    notifyListeners();
  }

  //UNBLOCK USER
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = auth.currentUser;
    await firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //GET BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userId) {
    return firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //this is a list of blocked users for the specific user with the required id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUserIds
          .map((id) => firestore.collection('Users').doc(id).get()));

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  //=========TO MARK THE MESSAGE AS READ =========
//    Future<void> markMessagesAsRead(String chatRoomID) async {
//   await firestore
//       .collection("chat_rooms")
//       .doc(chatRoomID)
//       .collection("messages")
//       .get()
//       .then((querySnapshot) {
//     querySnapshot.docs.forEach((doc) {
//       if (doc['isRead'] == false) {
//         doc.reference.update({"isRead": true});
//       }
//     });
//   });
// }

Future<void> markMessageAsRead(String chatRoomID, String messageId, String userId) async {
    await firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageId)
        .update({"isRead": userId});
  }


}
