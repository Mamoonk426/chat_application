import 'package:chat_application/providers/themProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Hi',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<Themprovider>(
            builder: (context, val, child) => Switch(
              value: val.isDark,
              onChanged: (value) {
                val.settheme();
                print(!value);
              },
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Press')),
        ],
      ),
    );
  }
}
