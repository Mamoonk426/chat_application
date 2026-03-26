import 'package:flutter/material.dart';

class Sendbutton extends StatefulWidget {
  Function()? send;
  Sendbutton({super.key, this.send});

  @override
  State<Sendbutton> createState() => _SendbuttonState();
}

class _SendbuttonState extends State<Sendbutton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.send,
      customBorder: const CircleBorder(),
      child: Center(
        child: Icon(
          Icons.send,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 20,
        ),
      ),
    );
  }
}

