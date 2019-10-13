import 'package:meta/meta.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour});
  final String name;
  final int ratePerHour;

  static Job fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Job(name: map['name'], ratePerHour: map['ratePerHour']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
