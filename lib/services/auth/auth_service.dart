import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chat/chat_service.dart';

class AuthService {
  //fireBase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatService chat = ChatService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  

  //get the current user
  User? getCurrent() {
    return _auth.currentUser;
  }

  //SIGN IN
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save the users in a doc
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //SIGN OUT
  Future<void> singOut() async {
    return _auth.signOut();
  }

  //SIGN UP
  Future<UserCredential> signUp(String email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save the users in a doc
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //DELETE ACCOUNT
  Future<void> deleteAccount() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Delete user documents from Firestore
        await firestore.collection('Users').doc(currentUser.uid).delete();

        // Delete the user from Firebase Authentication
        await currentUser.delete();

        // Sign out the user
        await singOut();


        return;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to delete account: ${e.message}');
    }
  }
}
