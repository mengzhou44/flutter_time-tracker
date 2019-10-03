import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign-in/sign-in-page.dart';
import '../sign-in/sign-in-page.dart';
import '../home-page/home-page.dart';
import '../common/services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;
  LandingPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(auth: auth);
          }
          return HomePage(auth: auth);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
