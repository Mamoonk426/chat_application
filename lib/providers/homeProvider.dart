import 'dart:async';

import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/services/cacheservices.dart';
import 'package:chat_application/services/connectivity_Services.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:chat_application/view/chatListScreen.dart';
import 'package:chat_application/view/profileDetails.dart';
import 'package:chat_application/view/requestScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homeprovider with ChangeNotifier {
  final Chatprovider chatProvider;
  ConnectivityServices connectivityServices = ConnectivityServices();
  Cacheservices cacheservices = Cacheservices();
  StreamSubscription<bool>? connectivityStream;
  bool _isDisposed = false;

  Homeprovider({required this.chatProvider});
  Widget bodyBuild(int index) {
    switch (index) {
      case 0:
        return Chatlistscreen();
      case 1:
        return Requestscreen();
      case 2:
        return Profiledetails();
      default:
        return Chatlistscreen();
    }
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  //This Function Will Listen To Connectivity Of Wifi And Mobile Data
  Future<void> listentoConnectionStatus() async {
    bool isconnected = false;
    print(
      'COnnectivity Stream Called ==========--------> CALLED ::: >>>>>>+++>>>>+++====',
    );
    connectivityStream?.cancel();
    connectivityStream = connectivityServices.checkConnectivity().listen((
      connection,
    ) async {
      isconnected = connection;
      print("Network connection status changed to: $isconnected");
      if (!_isDisposed) {
        notifyListeners();
      }
      if (!isconnected) {
        if (!_isDisposed) {
          notifyListeners();
        }
        print("Internet DisConnected");
      } else {
        final failedmessages = await cacheservices.getFailedMessages();
        print(
          'Connectivity Restored. Found ${failedmessages.length} failed messages to resend.',
        );
        if (failedmessages.isNotEmpty) {
          print('Failed Messages Found : ${failedmessages.length} Sending Now');
          for (var message in failedmessages) {
            await chatProvider.startChat(message.receiverId, message.message);
            await cacheservices.deleteFailedMessages(message.messageId);
          }
        }
        print('Reconnected');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream?.cancel();
    _isDisposed = true;
  }

  void updatechat(Chatprovider chatProvider) {
    // This method will be called when the Chatprovider updates
    // You can perform any necessary updates here based on the new Chatprovider state
    print("Chatprovider updated in Homeprovider");
    notifyListeners(); // Notify listeners to rebuild UI if needed
  }
}
