import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  String title;
  String subtitle;
  bool? status;
  Function()? onPressed;
  bool? isOnline;

  Usertile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onPressed,
    this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border(
            left: BorderSide(
              width: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
            // right: BorderSide(
            //   color: Theme.of(context).colorScheme.primary,
            //   width: 2,
            // ),
            // top: BorderSide(
            //   color: Theme.of(context).colorScheme.primary,
            //   width: 2,
            // ),
            // bottom: BorderSide(
            //   color: Theme.of(context).colorScheme.primary,
            //   width: 2,
            // ),
          ),
        ),
        height: 75,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.inversePrimary,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(title)),
              ),
              SizedBox(width: 30),
              SizedBox(
                width: 100,
                height: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(subtitle),
                    Text(isOnline == true ? 'Online' : 'Offline'),
                  ],
                ),
              ),
              SizedBox(width: 110),
              InkWell(
                onTap: () {
                  onPressed;
                },
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(Icons.add, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
