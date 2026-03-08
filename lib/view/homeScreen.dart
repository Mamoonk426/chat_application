import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/view/chatListScreen.dart';
import 'package:chat_application/view/requestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<Homeprovider>(context);
    print('B U I L D E D ');
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: homeProvider.currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (value) {
          homeProvider.setIndex(value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Chats ',
            icon: ImageIcon(AssetImage('assets/icons/Chaticon.png'), size: 30),
          ),
          BottomNavigationBarItem(
            label: 'Requests',
            icon: ImageIcon(AssetImage('assets/icons/Groupicon.png'), size: 30),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: ImageIcon(
              AssetImage('assets/icons/Profileicon.png'),
              size: 30,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: homeProvider.currentIndex,
        children: [
          Chatlistscreen(),
          Requestscreen(),
          Center(child: Text('Profile')),
        ],
      ),
    );
  }
}
