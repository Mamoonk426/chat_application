import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/view/chatListScreen.dart';
import 'package:chat_application/view/profileDetails.dart';
import 'package:chat_application/view/requestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool _isloaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isloaded) {
      final home = Provider.of<Homeprovider>(context, listen: false);
      home.listentoConnectionStatus();
      _isloaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<Homeprovider>(context);
    print('B U I L D E D ');
    return Scaffold(
      bottomNavigationBar: Container(
        height: 83,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.65),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: homeProvider.currentIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedLabelStyle: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withOpacity(0.5),
              ),
              selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedItemColor: Colors.grey.shade500,
              type: BottomNavigationBarType.shifting,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              onTap: (value) {
                homeProvider.setIndex(value);
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Chats',
                  icon: ImageIcon(
                    AssetImage('assets/icons/Chaticon.png'),
                    size: 22,
                  ),

                  activeIcon: ImageIcon(
                    AssetImage('assets/icons/Chaticon.png'),
                    size: 26,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Requests',
                  icon: ImageIcon(
                    AssetImage('assets/icons/Groupicon.png'),
                    size: 22,
                  ),
                  activeIcon: ImageIcon(
                    AssetImage('assets/icons/Groupicon.png'),
                    size: 26,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Profile',
                  icon: ImageIcon(
                    AssetImage('assets/icons/Profileicon.png'),
                    size: 22,
                  ),
                  activeIcon: ImageIcon(
                    AssetImage('assets/icons/Profileicon.png'),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      body: homeProvider.bodyBuild(homeProvider.currentIndex),
    );
  }
}
