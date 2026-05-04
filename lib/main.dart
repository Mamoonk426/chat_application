import 'package:chat_application/Cache/chat_model.dart';
import 'package:chat_application/Cache/failed_message_model.dart';
import 'package:chat_application/Cache/message_model.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/providers/addChatProvider.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/providers/loginProvider.dart';
import 'package:chat_application/providers/registerProivder.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/providers/themProvider.dart';
import 'package:chat_application/providers/userProvider.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/notificationServices.dart';
import 'package:chat_application/view/homeScreen.dart';
import 'package:chat_application/view/loginScreen.dart';
import 'package:chat_application/view/registerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveFailedMessageModelAdapter());
  Hive.registerAdapter(HiveMessageModelAdapter());
  Hive.registerAdapter(HiveChatModelAdapter());
  // Robust Firebase initialization to handle rare sync issues
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    // If it's already initialized, we can safely ignore this error
    debugPrint("Firebase initialization handled: $e");
  }

  await Messagingservices().initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Themprovider()),
        ChangeNotifierProvider(create: (_) => Registerproivder()),
        ChangeNotifierProvider(create: (_) => Loginprovider()),
        ChangeNotifierProvider(create: (_) => addChatprovider()),
        ChangeNotifierProvider(create: (_) => Requestprovider()),
        ChangeNotifierProvider(create: (_) => Chatprovider()),
        ChangeNotifierProvider(create: (_) => Userprovider()),
        ChangeNotifierProxyProvider<Chatprovider, Homeprovider>(
          create: (context) => Homeprovider(chatProvider: Chatprovider()),
          update: (context, chatProvider, homeProvider) {
            return homeProvider!..updatechat(chatProvider);
          },
        ),
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
