import 'package:flutter/material.dart';
import 'email-sign-in-form-change-notifier.dart';
 

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker'), elevation: 2),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          //child: Card(child: EmailSignInForm.create(context)),
          child: Card(child: EmailSignInFormChangeNotifier.create(context)),
        ),
      ),
    );
  }
}
