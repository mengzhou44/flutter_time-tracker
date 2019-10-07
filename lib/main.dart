import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './app/landing-page/landing-page.dart';

import 'app/common/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
          title: 'Time Tracker',
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: LandingPage()),
    );
  }
}
