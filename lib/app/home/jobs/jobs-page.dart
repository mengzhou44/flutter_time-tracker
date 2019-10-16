import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/job-entries/job_entries_page.dart';
import 'package:flutter_time_tracker/app/home/jobs/job-list-tile.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

import 'edit-job-page.dart';
import 'list-items-builder.dart';
import 'package:flutter/services.dart';

class JobsPage extends StatelessWidget {
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
    Database database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                EditJobPage.show(context, job: null, database: database);
              })
        ],
      ),
      body: _buildContent(context),
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
                        onTap: () => JobEntriesPage.show(context, job)),
                  ));
        });
  }
}
