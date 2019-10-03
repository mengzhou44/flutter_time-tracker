import 'package:flutter/material.dart';
import '../common/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;
  HomePage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
              child: Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                auth.signOut();
              })
        ],
      ),
    );
  }
}
