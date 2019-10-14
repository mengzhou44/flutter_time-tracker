import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/jobs/job-list-tile.dart';
import 'package:flutter_time_tracker/common_widgets/platform-alert-dialog.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';

import 'package:provider/provider.dart';

import 'edit-job-page.dart';
import 'list-items-builder.dart';
import 'package:flutter/services.dart';

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

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      Database database = Provider.of<Database>(context);
      database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
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
            EditJobPage.show(context, job: null);
          }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot,
            builder: (context, job) => Dismissible(
              background: Container(color: Colors.red),
              key: Key('job-${job.id}'),
              onDismissed: (direction) {
                _delete(context, job);
              },
              child: JobListTile(
                job: job,
                onTap: () => EditJobPage.show(context, job: job),
              ),
            ),
          );
        });
  }
}
