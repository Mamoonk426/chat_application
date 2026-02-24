import 'dart:math';

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

  Future<bool> register(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty) {
      Toasts.errorToast('enter Email and Password ');
      return false;
    }
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      Usermodel usermodel = Usermodel(
        id: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await storeUser(usermodel);
    } on FirebaseAuthException catch (e) {
      Toasts.errorToast(e.message ?? 'Authentication error');
      return false;
    } catch (e) {
      Toasts.errorToast(e.toString());
      return false;
    }
    Toasts.successToast('Registered Successfully');
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Toasts.errorToast('Please Fill all Fields');
      return false;
    }
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Toasts.successToast('Login Successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Toasts.errorToast(e.toString());
      return false;
    }
  }
}
