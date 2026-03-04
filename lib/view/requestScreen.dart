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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 150),
            Expanded(
              child: ListView.builder(
                itemCount: request.requests!.length,
                itemBuilder: (context, index) {
                  final data = request.requests;
                  if (data!.isEmpty) {
                    return Center(child: Text('No Data Found'));
                  }

                  return Card(
                    child: ListTile(
                      title: Text(
                        request.names[data[index].receiverId].toString(),
                      ),
                      subtitle: Text(data[index].status.toString()),
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
