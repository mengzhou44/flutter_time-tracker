import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/home-page.dart';

import 'package:flutter_time_tracker/app/sign-in/sign-in-page.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
 
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthBase>(context, listen: false).onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<User>.value(
              value: user,
              child: Provider<Database>(
              builder: (_) => FirestoneDatebase(uid: user.userId),
              child: HomePage(),
            ),
          );
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
