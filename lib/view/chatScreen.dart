import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/view/addChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<Chatprovider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addchatscreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chats', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Customformfield(
                suffixImage: IconButton(
                  onPressed: () async {},
                  icon: ImageIcon(AssetImage('assets/icons/Magnifier.png')),
                ),
                title: 'Search Your Chats',
                controller: searchController,
              ),
              SizedBox(height: 10),
              // Expanded(
              //   child: FutureBuilder(
              //     future: chat.getUser(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData &&
              //           snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       }
              //       if (!snapshot.hasData) {
              //         return Center(child: Text('No User found'));
              //       }
              //       final data = chat.filterUser();
              //       return ListView.builder(
              //         itemCount: data.length,
              //         itemBuilder: (context, index) {
              //           return Card(child: Text(data[index].email));
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
