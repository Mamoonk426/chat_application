import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/providers/loginProvider.dart';
import 'package:chat_application/providers/registerProivder.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/providers/themProvider.dart';
import 'package:chat_application/view/homeScreen.dart';
import 'package:chat_application/view/loginScreen.dart';
import 'package:chat_application/view/registerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Homeprovider()),
        ChangeNotifierProvider(create: (_) => Themprovider()),
        ChangeNotifierProvider(create: (_) => Registerproivder()),
        ChangeNotifierProvider(create: (_) => Loginprovider()),
        ChangeNotifierProvider(create: (_) => Chatprovider()),
        ChangeNotifierProvider(create: (_) => Requestprovider()),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginscreen(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Themprovider>(context).themeData,
    );
  }
}
