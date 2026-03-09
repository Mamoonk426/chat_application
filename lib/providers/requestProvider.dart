import 'dart:async';

import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/requestModel.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/requestServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requestprovider with ChangeNotifier {
  Future<void> acceptRequest(String docId, BuildContext context) async {
    await requestservices.acceptRequest(docId, context);
    Toasts.successToast('Requested Accepted', context);
  }

  StreamSubscription? _recievedRequestsStream;
  StreamSubscription? _recievedRequestsNames;
  StreamSubscription? get recievedRequestsNames => _recievedRequestsNames;
  Map<String, String> _names = {};
  Map<String, String> get names => _names;
  Requestservices requestservices = Requestservices();
  List<RequestModel> _requests = [];
  List<RequestModel>? get requests => _requests;
  Set<String> chips = {'Accepted', 'Pending'};
  Set<String> selectedchips = {'Pending'}; // Restore default to Pending

  void toggleChip(String chip) {
    if (selectedchips.contains(chip)) {
      selectedchips.remove(chip);
    } else {
      selectedchips.add(chip);
    }
    notifyListeners();
  }

  List<RequestModel> getFilteredRequests() {
    if (selectedchips.isEmpty) return _requests;
    return _requests.where((req) {
      return selectedchips.contains(req.status);
    }).toList();
  }
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
