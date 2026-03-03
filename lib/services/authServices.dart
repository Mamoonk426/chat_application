import 'dart:math';
import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authservices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? currentUser;

  Future<void> storeUser(Usermodel userModel) async {
    await db.collection('Users').doc(userModel.id).set(userModel.toMap());
  }

  Future<bool> register(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    if (!context.mounted) return false;
    if (email.isEmpty || password.isEmpty) {
      Toasts.errorToast('enter Email and Password', context);
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
        createdAt: FieldValue.serverTimestamp(),
      );
      currentUser = firebaseAuth.currentUser;
      await storeUser(usermodel);
    } on FirebaseAuthException catch (e) {
      Toasts.errorToast(e.message ?? 'Authentication error', context);
      return false;
    } catch (e) {
      Toasts.errorToast(e.toString(), context);
      return false;
    }
    Toasts.successToast('Registered Successfully', context);
    return true;
  }

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    if (!context.mounted) {
      return false;
    }
    if (email.isEmpty || password.isEmpty) {
      Toasts.errorToast('Please Fill all Fields', context);
      return false;
    }
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Toasts.successToast('Login Successfully', context);
      currentUser = firebaseAuth.currentUser;
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Toasts.errorToast(e.toString(), context);
      return false;
    }
  }
}
