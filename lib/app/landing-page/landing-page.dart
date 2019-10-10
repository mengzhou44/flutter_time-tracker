import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign-in/sign-in-page.dart';
import 'package:provider/provider.dart';
import '../sign-in/sign-in-page.dart';
import '../home-page/home-page.dart';
import '../common/services/auth.dart';

class LandingPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthBase>(context).onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
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
