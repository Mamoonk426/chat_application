import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/providers/addChatProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userprofilescreen extends StatefulWidget {
  Usermodel user;
  Userprofilescreen({super.key, required this.user});

  @override
  State<Userprofilescreen> createState() => _UserprofilescreenState();
}

class _UserprofilescreenState extends State<Userprofilescreen> {
  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<addChatprovider>(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Text('User Profile', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 30),
          Card(
            child: Container(
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Text(
                        chat.extracting(widget.user.name),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      widget.user.name.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Card(
            child: Column(
              children: [
                ListTile(
                  subtitle: Text('Phone Number'),
                  title: Text(widget.user.email),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
