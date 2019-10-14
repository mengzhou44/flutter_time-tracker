import 'package:flutter_time_tracker/models/job.dart';
import 'package:meta/meta.dart';

import 'api-path.dart';
import 'firestore-service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoneDatebase implements Database {
  FirestoneDatebase({@required this.uid}) : assert(uid != null);
  final String uid;

  FirestoreService _instance = FirestoreService.instance;

  Future<void> setJob(Job job) async => await _instance.setData(
        path: APIPath.job(uid: uid, jobId: job.id),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _instance.collectionStream<Job>(
      path: APIPath.jobs(uid: uid), 
      builder: (data, documentId) => Job.fromMap(data, documentId)
  );
}



 
 