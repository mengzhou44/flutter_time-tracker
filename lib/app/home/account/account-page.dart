import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/avatar.dart';
import 'package:flutter_time_tracker/common_widgets/platform-alert-dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      AuthBase auth = Provider.of<AuthBase>(context);
      auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool confirmed = await PlatformAlertDialog(
            title: 'Logout',
            content: 'Are you sure you want to logout?',
            defaultActionText: 'Ok',
            defaultCancelText: 'Cancel')
        .show(context);
    if (confirmed == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      title: Text('Account'),
      actions: [
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
        ),
      ],
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(130), child: _buildUserInfo(user)),
    ));
  }

  Widget _buildUserInfo(User user) {
    return Column(
        children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.displayName != null ) 
           Text(user.displayName, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
      ],
    );
  }
}
