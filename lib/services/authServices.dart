import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authservices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> storeUser(Usermodel userModel) async {
    await db.collection('Users').doc(userModel.id).set(userModel.toMap());
  }

  Future<bool> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Toasts.errorToast('enter Email and Password ');
      return false;
    }
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Toasts.errorToast(e.toString());
      return false;
    }
    return true;
  }
}
