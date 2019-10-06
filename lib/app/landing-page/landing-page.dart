import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth-provider.dart';
import 'package:flutter_time_tracker/app/sign-in/sign-in-page.dart';
import '../sign-in/sign-in-page.dart';
import '../home-page/home-page.dart';
import '../common/services/auth.dart';

class LandingPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthProvider.of(context).onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
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
