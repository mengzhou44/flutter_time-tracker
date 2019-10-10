import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_tracker/app/sign-in/sign-in-bloc.dart';
import 'package:provider/provider.dart';
import './sign-in-button.dart';
import '../common/services/auth.dart';
import './email-sign-in-page.dart';
import '../common/widgets/platform-exception-alert-dialog.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
        builder: (_) => SignInBloc(auth: auth),
        child: Consumer<SignInBloc>(
          builder: (context, bloc, _) => SignInPage(bloc: bloc),
        ),
        dispose: (context, bloc) => bloc.dispose());
  }

  _showSignInError(BuildContext context, PlatformException e) {
    if (e.code != 'ERROR_USER_ABORT') {
       PlatformExceptionAlertDialog(title: 'Sign in failed', exception: e)
        .show(context);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } catch (exception) {
      _showSignInError(context, exception);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } catch (exception) {
      _showSignInError(context, exception);
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
      await bloc.signInWithFacebook();
    } catch (exception) {
      _showSignInError(context, exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker'), elevation: 2),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, isLoading) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50, child: _buildHeader(isLoading)),
          SizedBox(height: 50),
          SignInButton(
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading
                  ? null
                  : () {
                      _signInWithGoogle(context);
                    },
              logo: Image.asset('images/google-logo.png')),
          SizedBox(height: 8),
          SignInButton(
              text: 'Sign in with Facebook',
              textColor: Colors.white,
              color: Color(0xff334d92),
              onPressed: isLoading
                  ? null
                  : () {
                      _signInWithFacebook(context);
                    },
              logo: Image.asset('images/facebook-logo.png')),
          SizedBox(height: 8),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () {
              _signInWithEmail(context);
            },
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
              onPressed: isLoading
                  ? null
                  : () {
                      _signInAnonymously(context);
                    }),
        ],
      ),
    );
  }

  Widget _buildHeader(isLoading) {
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
