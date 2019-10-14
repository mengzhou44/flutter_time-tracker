import 'package:flutter_time_tracker/models/job.dart';
import 'package:meta/meta.dart';

import 'api-path.dart';
import 'firestore-service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoneDatebase implements Database {
  FirestoneDatebase({@required this.uid}) : assert(uid != null);
  final String uid;

  FirestoreService _service = FirestoreService.instance;
   
  @override 
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid: uid, jobId: job.id),
        data: job.toMap(),
      );

  @override 
  Stream<List<Job>> jobsStream() => _service.collectionStream<Job>(
      path: APIPath.jobs(uid: uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override 
  Future<void> deleteJob(Job job) async =>
      await _service.deleteData(path: APIPath.job(uid: uid, jobId: job.id));
}
