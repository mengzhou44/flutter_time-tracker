import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth-provider.dart';
import './sign-in-button.dart';
import '../common/services/auth.dart';
import './email-sign-in-page.dart';

class SignInPage extends StatelessWidget {
 
  Future<void> _signInAnonymously(BuildContext context) async {
    try {

        final AuthBase auth = AuthProvider.of(context);
        auth.signInAnonymously();
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
         final AuthBase auth = AuthProvider.of(context);
      await auth.signInWithGoogle();
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
       final AuthBase auth = AuthProvider.of(context);
      await auth.signInWithFacebook();
    } catch (exception) {
      print(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker'), elevation: 2),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 50),
          SignInButton(
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: () {_signInWithGoogle(context); },
              logo: Image.asset('images/google-logo.png')),
          SizedBox(height: 8),
          SignInButton(
              text: 'Sign in with Facebook',
              textColor: Colors.white,
              color: Color(0xff334d92),
              onPressed: () {_signInWithFacebook(context); },
              logo: Image.asset('images/facebook-logo.png')),
          SizedBox(height: 8),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () { _signInWithEmail(context); },
          ),
          SizedBox(height: 8),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(height: 8),
          SignInButton(
              text: 'Go anonymous',
              textColor: Colors.black,
              color: Colors.lime[300],
              onPressed: (){_signInAnonymously(context);}),
        ],
      ),
    );
  }
}
