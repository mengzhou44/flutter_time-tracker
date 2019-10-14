import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  EmptyContent(
      {Key key,
      this.title = 'Noting here!',
      this.message = 'Add a job to get started.'})
      : super(key: key);

  final String title;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 32, color: Colors.black54)),
            Text(message,
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          ]),
    );
  }
}
