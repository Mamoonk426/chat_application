import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:flutter/material.dart';
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
      extendBody: true,
      bottomNavigationBar: Container(
        height: 85,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: homeProvider.currentIndex,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.4),
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: (value) {
                homeProvider.setIndex(value);
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Chats',
                  icon: Icon(Icons.chat_bubble_outline_rounded, size: 24),
                  activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
                ),
                BottomNavigationBarItem(
                  label: 'Requests',
                  icon: Icon(Icons.people_outline_rounded, size: 24),
                  activeIcon: Icon(Icons.people_rounded, size: 28),
                ),
                BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(Icons.person_outline_rounded, size: 24),
                  activeIcon: Icon(Icons.person_rounded, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
      body: homeProvider.bodyBuild(homeProvider.currentIndex),
    );
  }
}
