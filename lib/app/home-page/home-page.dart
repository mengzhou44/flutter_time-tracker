import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth-provider.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';
import 'package:flutter_time_tracker/app/common/widgets/patform-alert-dialog.dart';
 

class HomePage extends StatelessWidget {


  Future<void> _signOut(BuildContext context) async {
    try {
      AuthBase auth = AuthProvider.of(context);
      auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool confirmed = await PlatformAlertDialog(
            title: 'Logout',
            content: 'Are you syre you want to logout?',
            defaultActionText: 'Ok',
            defaultCancelText: 'Cancel')
        .show(context);
    if (confirmed == true) {
      _signOut(context);
    }
  }

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
              _confirmSignOut(context);
            },
          )
        ],
      ),
    );
  }
}
