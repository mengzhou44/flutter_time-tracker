import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_time_tracker/app/home/jobs/edit-job-page.dart';
import 'package:flutter_time_tracker/app/home/jobs/list-items-builder.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/entry.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'entry_list_item.dart';
import 'entry_page.dart';
 

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => EditJobPage.show(
                    context,
                    database: database,
                    job: job,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    job: job,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          builder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
