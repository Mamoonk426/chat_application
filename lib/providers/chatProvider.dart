import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:flutter/material.dart';

class Chatprovider with ChangeNotifier {
  Getuserservices getuserservices = Getuserservices();
  String? _searchQuery;
  String? get searchQuery => _searchQuery;
  Future<List<Usermodel>> getUser(String email) async {
    final data = await getuserservices.getUsers();
    _emaildata = data;
    notifyListeners();
    return data;
  }

  List<Usermodel> _emaildata = [];
  List<Usermodel> get emaildata => _emaildata;
  List<Usermodel> _filtereddata = [];
   <List<Usermodel> filterUser()   {
    return _filtereddata = _emaildata
        .where((user) => user.email.contains(_searchQuery.toString()))
        .toList();
  }
}
