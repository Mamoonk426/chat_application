import 'package:chat_application/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    final chat = Theme.of(context).extension<AppChatTheme>()!;
    return Scaffold(
      backgroundColor: chat.chatBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 35, child: Icon(Icons.person)),
                  SizedBox(width: 40),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          'Mamoon Khan',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text('4 min ago'),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.call),
                  SizedBox(width: 30),
                  Icon(Icons.video_call),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
