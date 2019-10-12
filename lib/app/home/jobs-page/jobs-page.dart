import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/platform-alert-dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';
 
import 'package:provider/provider.dart';
 

class JobsPage extends StatelessWidget {


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
            content: 'Are you syre you want to logout?',
            defaultActionText: 'Ok',
            defaultCancelText: 'Cancel')
        .show(context);
    if (confirmed == true) {
      _signOut(context);
    }
  }

  void _createJob(BuildContext context) async {
       final database= Provider.of<Database>(context);
       await database.createJob({
          'name': 'Blogging',
          'ratePerHour': 30
       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
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
      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){_createJob(context);}
        ),
    );
  }
}
