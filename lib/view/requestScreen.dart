import 'package:chat_application/components/requestTile.dart';
import 'package:chat_application/components/userTile.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/view/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MMM d, h:mm a').format(dateTime);
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
            Wrap(
              spacing: 8,
              children: List.generate(request.chips.length, (index) {
                final chip = request.chips.toList();
                final fchip = chip[index];
                return FilterChip(
                  selected: request.selectedchips.contains(fchip),
                  selectedColor: Theme.of(context).colorScheme.inversePrimary,
                  label: Text(fchip),
                  onSelected: (c) {
                    request.toggleChip(fchip);
                  },
                );
              }),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: request.getFilteredRequests().length,
                itemBuilder: (context, index) {
                  final data = request.getFilteredRequests();
                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        'No Data Found',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    );
                  }
                  return Requesttile(
                    isAccepted: data[index].status == 'Accepted',
                    startChat: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chatscreen()),
                      );
                      print('Navigated');
                    },
                    confirmCall: () async {
                      await request.acceptRequest(
                        data[index].requestId,
                        context,
                      );

                      print('ACCEPTED');
                    },

                    title: request.names[data[index].senderId].toString(),

                    trailing: _formatTime(data[index].createdAt),

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
