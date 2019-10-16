import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker/common_widgets/format.dart';
import 'package:flutter_time_tracker/models/entry.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:rxdart/rxdart.dart';

import 'daily-job-details.dart';
import 'entry-job.dart';
import 'entry-list-tile.dart';

class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryJob>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
