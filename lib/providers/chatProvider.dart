import 'dart:async';

import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:chat_application/services/requestServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatprovider with ChangeNotifier {
  final Requestservices requestservices = Requestservices();
  final Getuserservices getuserservices = Getuserservices();

  StreamSubscription<Set<String>>? _sentRequestsSubscription;
  Set<String> _sentRequestReceiverIds = {};

  bool hasSentRequestTo(String receiverId) {
    print(" HasSentTheRequest $_sentRequestReceiverIds.contains(receiverId)");
    return _sentRequestReceiverIds.contains(receiverId);
  }

  void listenSentRequests() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _sentRequestsSubscription?.cancel();
      _sentRequestsSubscription = null;
      _sentRequestReceiverIds = {};
      notifyListeners();
      return;
    }

    _sentRequestsSubscription?.cancel();
    _sentRequestsSubscription = requestservices
        .sentRequestReceiverIdsStream(currentUser.uid)
        .listen((receiverIds) {
          _sentRequestReceiverIds = receiverIds;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _sentRequestsSubscription?.cancel();
    super.dispose();
  }

  String extracting(String name) {
    List<String> splitName = name.split(' ');
    String? title;
    if (splitName.isEmpty) return " ";
    if (splitName.length == 1) {
      return title = splitName[0].substring(0, 1).toUpperCase();
    } else if (!name.contains(RegExp(r'\s'))) {
      return title = splitName[0].substring(0, 1).toUpperCase();
    } else {
      for (int i = 0; i < splitName.length; i++) {
        if (i == splitName.length - 1) {
          break;
        }
        title =
            splitName[0].substring(0, 1) +
            splitName[1].substring(0, 1).toUpperCase();
      }
      return title!;
    }
  }

  String? _searchQuery;
  String? get searchQuery => _searchQuery;

  void setQuery(String? query) {
    _searchQuery = query;
    filterUser();
    notifyListeners();
  }

  Future<List<Usermodel>> getUser() async {
    final data = await getuserservices.getUsers();

    _emaildata = data;
    _filtereddata = _emaildata; // Show all users initially
    notifyListeners();
    return data;
  }

  List<Usermodel> _emaildata = [];
  List<Usermodel> _filtereddata = [];
  List<Usermodel> get filtereddata => _filtereddata;

  List<Usermodel> filterUser() {
    if (_searchQuery == null || _searchQuery!.trim().isEmpty) {
      // Show all users when query is empty
      _filtereddata = _emaildata;
    } else {
      _filtereddata = _emaildata
          .where(
            (user) =>
                user.name.toLowerCase().contains(_searchQuery!.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
    return _filtereddata;
  }

  Future<void> sendRequests(String recieverId, BuildContext context) async {
    try {
      await requestservices.sendRequest(recieverId);
      _sentRequestReceiverIds = {..._sentRequestReceiverIds, recieverId};
      notifyListeners();
      Toasts.successToast('Request sent', context);
    } catch (e) {
      Toasts.errorToast(e.toString(), context);
    }
  }
}
