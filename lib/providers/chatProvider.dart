import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:flutter/material.dart';

class Chatprovider with ChangeNotifier {
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

  Getuserservices getuserservices = Getuserservices();
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
    _filtereddata = []; // Show all users initially
    notifyListeners();
    return data;
  }

  List<Usermodel> _emaildata = [];
  List<Usermodel> _filtereddata = [];
  List<Usermodel> get filtereddata => _filtereddata;

  List<Usermodel> filterUser() {
    if (_searchQuery == null || _searchQuery!.trim().isEmpty) {
      // Show all users when query is empty
      _filtereddata = [];
    } else {
      _filtereddata = _emaildata
          .where(
            (user) =>
                user.email.toLowerCase().contains(_searchQuery!.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
    return _filtereddata;
  }
}
