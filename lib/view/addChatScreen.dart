import 'package:chat_application/components/customFormField.dart';
import 'package:chat_application/components/userTile.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/view/userProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addchatscreen extends StatefulWidget {
  const Addchatscreen({super.key});

  @override
  State<Addchatscreen> createState() => _AddchatscreenState();
}

class _AddchatscreenState extends State<Addchatscreen> {
  final TextEditingController _search = TextEditingController();
  bool _isLoaded = false;
  List<String> chips = ['All', 'Online', 'Nearby'];
  bool isOnline = false;
  Set<String> selectedchips = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      print(_isLoaded);
      _isLoaded = true;
      print(_isLoaded);
      final chatProvider = Provider.of<Chatprovider>(context, listen: false);
      chatProvider.getUser();
      chatProvider.listenSentRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<Chatprovider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover Peoples',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.inversePrimary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),

                    height: 50,
                    width: 50,
                    child: Center(
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Customformfield(
                title: 'Search people,tags,names',
                controller: _search,
                onChanged: (value) {
                  chat.setQuery(value);
                },
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: chat.filtereddata.length,
                  itemBuilder: (context, index) {
                    final data = chat.filtereddata;
                    if (data.isEmpty) {
                      return Center(child: Text('No User Found'));
                    }
                    final user = data[index];
                    var title = chat.extracting(user.name);
                    final hasSentRequest = chat.hasSentRequestTo(user.id);

                    return Usertile(
                      onPressed: () async {
                        if (hasSentRequest) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Userprofilescreen(user: user),
                            ),
                          );
                          return;
                        }

                        await chat.sendRequests(user.id, context);
                      },
                      leading: title,
                      title: user.name,
                      status: user.isOnline,
                      actionLabel: hasSentRequest ? 'View profile' : 'Add',
                      actionIcon: hasSentRequest ? Icons.person : Icons.add,
                    );
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
