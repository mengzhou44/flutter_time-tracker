import 'package:flutter_time_tracker/models/entry.dart';
import 'package:flutter_time_tracker/models/job.dart';
 
class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Job job;
}
