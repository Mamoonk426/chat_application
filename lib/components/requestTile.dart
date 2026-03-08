import 'package:flutter/material.dart';

class Requesttile extends StatefulWidget {
  String? leading;
  String? title;
  String? trailing;
  Function? confirmCall;
  Function? cancelCall;
  bool isAccepted;
  Requesttile({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.cancelCall,
    this.confirmCall,
    this.isAccepted = false,
  });

  @override
  State<Requesttile> createState() => _RequesttileState();
}

class _RequesttileState extends State<Requesttile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircleAvatar(child: Text(widget.leading.toString())),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.trailing.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  if (widget.isAccepted)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'You are friends now',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.confirmCall!();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              minimumSize: Size(0, 35),
                            ),
                            child: Text('Confirm'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => widget.cancelCall,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              minimumSize: Size(0, 35),
                            ),
                            child: Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
