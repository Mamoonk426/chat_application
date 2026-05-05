import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Authservices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  User? currentUser;
  late final currentUserDoc;

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
        token: await Messagingservices().getToken(),
      );
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

  Future<void> logout() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;
    await firebaseDatabase.ref('presence/${user.uid}').set({
      'status': 'Offline',
    });
    debugPrint('Setted OFFLINE');
    await firebaseAuth.signOut();
  }

  Future<void> setUserStatus() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final connectedRef = firebaseDatabase.ref('.info/connected');

    // Listen to network connection state
    connectedRef.onValue.listen((event) async {
      final isConnected = event.snapshot.value as bool? ?? false;

      if (isConnected) {
        final presenceRef = firebaseDatabase.ref('presence/${user.uid}');

        try {
          // 1. Queue the disconnect operation on the server FIRST
          await presenceRef.onDisconnect().set({'status': 'Offline'});
          print('OnDisconnect Called');

          // 2. Safely tell the server we are Online
          presenceRef.set({'status': 'Online'});

          // 3. Keep Firestore roughly in sync
          db
              .collection('Users')
              .doc(user.uid)
              .update({'isOnline': true})
              .catchError((_) {});
        } catch (e) {
          debugPrint("Status update error: $e");
        }
      }
    });
  }

  Stream<bool> listenToType(String uid) {
    final typeRef = FirebaseDatabase.instance.ref('presence/typestatus/$uid');
    return typeRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return false;
      final map = Map<String, dynamic>.from(data as Map);
      return map['istyping'] == true;
    });
  }

  Future<void> setToType(String uid, bool isTyping) async {
    DatabaseReference typeRef = FirebaseDatabase.instance.ref(
      'presence/typestatus/$uid',
    );
    if (isTyping) {
      typeRef.set({'istyping': true});
      typeRef.onDisconnect().remove();
    } else {
      typeRef.set({'istyping': false});
    }
  }

  Stream<Map<String, dynamic>?> listenUserStatus(String otherUserUid) {
    final ref = FirebaseDatabase.instance.ref('presence/$otherUserUid');
    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return null;
      return Map<String, dynamic>.from(data as Map);
    });
  }
}
