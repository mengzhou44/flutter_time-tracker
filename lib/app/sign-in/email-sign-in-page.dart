import 'package:flutter/material.dart';
import 'email-sign-in-form.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase  auth;
  EmailSignInPage({this.auth});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Time Tracker'), elevation: 2),
        backgroundColor: Colors.grey[200],
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(child: EmailSignInForm(auth:auth))));
  }
}
