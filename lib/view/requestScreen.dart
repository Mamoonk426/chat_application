import 'package:chat_application/components/requestTile.dart';
import 'package:chat_application/components/userTile.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Requestscreen extends StatefulWidget {
  const Requestscreen({super.key});

  @override
  State<Requestscreen> createState() => _RequestscreenState();
}

class _RequestscreenState extends State<Requestscreen> {
  final bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      final requestProvider = Provider.of<Requestprovider>(
        context,
        listen: false,
      );
      requestProvider.listenTorecieveRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Requestprovider>(context);
    final chat = Provider.of<Chatprovider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Friend Requests',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: request.requests!.length,
                itemBuilder: (context, index) {
                  final data = request.requests;
                  if (data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No Data Found',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    );
                  }
                  return Requesttile(
                    title: request.names[data[index].senderId].toString(),

                    leading: chat.extracting(
                      request.names[data[index].senderId].toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
