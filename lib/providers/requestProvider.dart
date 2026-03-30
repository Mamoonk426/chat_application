import 'dart:async';

import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/requestModel.dart';
import 'package:chat_application/services/requestServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requestprovider with ChangeNotifier {
  Requestprovider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _recievedRequestsStream?.cancel();
        _recievedRequestsNames?.cancel();
        _sentRequestsStream?.cancel();
        _sentRequestsNames?.cancel();
        _friendsSubscription?.cancel();
        _requests = [];
        _sentRequests = [];
        _friends = [];
        _names = {};
        _receiverNames = {};
        notifyListeners();
      }
    });
  }

  Future<void> acceptRequest(String docId, BuildContext context) async {
    await requestservices.acceptRequest(docId, context);
    Toasts.successToast('Requested Accepted', context);
  }

  // ── Received requests ──
  StreamSubscription? _recievedRequestsStream;
  StreamSubscription? _recievedRequestsNames;
  StreamSubscription? get recievedRequestsNames => _recievedRequestsNames;
  Map<String, String> _names = {};
  Map<String, String> get names => _names;
  Requestservices requestservices = Requestservices();
  List<RequestModel> _requests = [];
  List<RequestModel>? get requests => _requests;

  // ── Sent requests ──
  StreamSubscription? _sentRequestsStream;
  StreamSubscription? _sentRequestsNames;
  List<RequestModel> _sentRequests = [];
  List<RequestModel> get sentRequests => _sentRequests;
  Map<String, String> _receiverNames = {};
  Map<String, String> get receiverNames => _receiverNames;

  // ── Friends List ──
  StreamSubscription? _friendsSubscription;
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> get friends => _friends;

  // ── Main Tab toggle ──
  bool _isFriendsTab = false;
  bool get isFriendsTab => _isFriendsTab;

  void toggleMainTab(bool isFriends) {
    _isFriendsTab = isFriends;
    notifyListeners();
  }

  // ── Tab toggle ──
  bool _isSentTab = false;
  bool get isSentTab => _isSentTab;

  void toggleTab(bool isSent) {
    _isSentTab = isSent;
    notifyListeners();
  }

  // ── Filter chips ──
  Set<String> chips = {'Sent', 'Received'};
  Set<String> selectedchips = {'Received'};

  void toggleChip(String chip) {
    // Make Sent/Received mutually exclusive
    selectedchips.clear();
    selectedchips.add(chip);
    notifyListeners();
  }

  bool get isSentSelected => selectedchips.contains('Sent');

  Map<String, String> get currentNamesMap =>
      isSentSelected ? _receiverNames : _names;

  List<RequestModel> getFilteredRequests() {
    if (isSentSelected) {
      return _sentRequests;
    } else {
      return _requests;
    }
  }

  // ── Listen to all requests ──
  Future<void> listenTorecieveRequest() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    _recievedRequestsStream = requestservices.getSentRequestStream(uid).listen((
      request,
    ) {
      _requests = request;
      notifyListeners();
    });

    _recievedRequestsNames = requestservices.getSenderNamesStream().listen((
      snapshot,
    ) {
      if (_names.toString() == snapshot.toString()) return;
      _names = snapshot;
      notifyListeners();
    });

    listenToSentRequests();
    listenToFriends();
  }

  // ── Listen to friends ──
  Future<void> listenToFriends() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _friendsSubscription = requestservices.getFriendsStream(uid).listen((
      friendsList,
    ) {
      _friends = friendsList;
      notifyListeners();
    });
  }

  // ── Listen to sent requests ──
  Future<void> listenToSentRequests() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    _sentRequestsStream = requestservices.getSentByMeRequestStream(uid).listen((
      requests,
    ) {
      _sentRequests = requests;
      notifyListeners();
    });

    _sentRequestsNames = requestservices.getReceiverNamesStream().listen((
      snapshot,
    ) {
      if (_receiverNames.toString() == snapshot.toString()) return;
      _receiverNames = snapshot;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _recievedRequestsStream?.cancel();
    _recievedRequestsNames?.cancel();
    _sentRequestsStream?.cancel();
    _sentRequestsNames?.cancel();
    _friendsSubscription?.cancel();
    super.dispose();
  }

  void clear() {
    _recievedRequestsStream?.cancel();
    _recievedRequestsNames?.cancel();
    _sentRequestsStream?.cancel();
    _sentRequestsNames?.cancel();
    _friendsSubscription?.cancel();
    _requests = [];
    _sentRequests = [];
    _friends = [];
    _names = {};
    _receiverNames = {};
    notifyListeners();
  }
}
