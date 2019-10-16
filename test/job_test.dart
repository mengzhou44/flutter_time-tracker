import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/models/job.dart';

void main() {
  group('job', () {
    group('fromMap', () {
      test('map null => job null', () {
        final result = Job.fromMap(null, 'abc');
        expect(result, null);
      });
      test('map all properties', () {
        Map<String, dynamic> map = {
          'name': 'buy ticket',
          'ratePerHour': 50,
        };

        final result = Job.fromMap(map, '34334');
        expect(
          result,
          Job(
            id: '34334',
            name: 'buy ticket',
            ratePerHour: 50,
          ),
        );
      });
    });

    group('toMap', () {
      test('job =>  map', () {
        Job job = Job(
          id: '34334',
          name: 'buy ticket',
          ratePerHour: 50,
        );
        final result = job.toMap();
        expect(result['name'], 'buy ticket');
        expect(result['ratePerHour'], 50);
      });
    });
  });
}
