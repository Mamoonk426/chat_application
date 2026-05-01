import 'dart:async';

import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier {
  Usermodel? _currentUser;
  bool _isLoading = true;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  Getuserservices getuserservices = Getuserservices();

  Usermodel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Userprovider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUser = null;
        _isLoading = false;
        _userSubscription?.cancel();
        _userSubscription = null;
        notifyListeners();
      } else {
        _listenToUserDoc(user.uid);
      }
    });
  }

  void _listenToUserDoc(String uid) {
    _userSubscription?.cancel();
    _userSubscription = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              _currentUser = Usermodel.fromMap(
                snapshot.data() as Map<String, dynamic>,
              );
              _checkAndUpdateToken(uid);
            } else {
              _currentUser = null;
            }
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint("Error listening to user document: $error");
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  Future<void> _checkAndUpdateToken(String uid) async {
    String? currentToken = await Messagingservices().getToken();
    debugPrint("DEBUG TOKEN: currentToken=$currentToken, currentUserToken=${_currentUser?.token}");
    if (currentToken != null && _currentUser?.token != currentToken) {
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'token': currentToken,
      });
      debugPrint("UserProvider: Token updated in Firestore");
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  void clear() {
    _userSubscription?.cancel();
    _userSubscription = null;
    _currentUser = null;
    _isLoading = true;
    notifyListeners();
  }

  Future<void> setUserStatus() async {
    await Authservices().setUserStatus();
  }

  Future<void> logout() async {
    await Authservices().logout();
    clear();
  }
}
