import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_tracker/common_widgets/platform-alert-dialog.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';

import 'package:provider/provider.dart';

import 'add-job-page.dart';

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
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AddJobPage.show(context);
          }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => Text(job.name)).toList();
            return ListView(children: children);
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
