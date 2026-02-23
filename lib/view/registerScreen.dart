import 'package:chat_application/providers/registerProivder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<Registerproivder>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            SizedBox(height: 100),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 200,
                    height: 170,
                    decoration: BoxDecoration(
                      image: registerProvider.image != null
                          ? DecorationImage(
                              image: FileImage(registerProvider.image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: registerProvider.image == null
                        ? Icon(Icons.add)
                        : null,
                  ),
                  Positioned(
                    top: 140,
                    left: 80,
                    child: InkWell(
                      onTap: () async {
                        await registerProvider.pickPic();
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onInverseSurface,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 200, height: 200, child: Column(children: [])),
          ],
        ),
      ),
    );
  }
}
