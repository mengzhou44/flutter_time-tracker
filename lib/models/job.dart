import 'dart:ui';

import 'package:meta/meta.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});
  final String id; 
  final String name;
  final int ratePerHour;

  static Job fromMap(Map<String, dynamic> map,String documentId, ) {
    if (map == null) return null;
    return Job(id: documentId, name: map['name'], ratePerHour: map['ratePerHour']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return  hashCode == otherJob.hashCode;
  }
}
