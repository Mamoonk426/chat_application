import 'dart:async';

import 'package:chat_application/models/requestModel.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/requestServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requestprovider with ChangeNotifier {
  StreamSubscription? _recievedRequestsStream;
  StreamSubscription? _recievedRequestsNames;
  StreamSubscription? get recievedRequestsNames => _recievedRequestsNames;
  Map<String, String> _names = {};
  Map<String, String> get names => _names;
  Requestservices requestservices = Requestservices();
  List<RequestModel> _requests = [];
  List<RequestModel>? get requests => _requests;
  Future<void> listenTorecieveRequest() async {
    _recievedRequestsStream = requestservices
        .getSentRequestStream(FirebaseAuth.instance.currentUser!.uid.toString())
        .listen((request) {
          _requests = request;
          notifyListeners();
        });

    _recievedRequestsNames = requestservices.getSenderNamesStream().listen((
      snapshot,
    ) {
      if (_names.toString() == snapshot.toString()) return;
      _names = snapshot;
      print(_names);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _recievedRequestsStream?.cancel();
    _recievedRequestsNames?.cancel();

    super.dispose();
  }
}
