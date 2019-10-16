import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/common_widgets/format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  group('hours', () {


     test('positive', () {
      expect(Format.hours(10), '10h');
    });

    test('zero', () {
      expect(Format.hours(0), '0h');
    });

    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
    
  });

  group('date', () {
      setUp(() async {
      Intl.defaultLocale = 'en_US';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('date 2019-08-01 format be Aug 1, 2019', () {
      final dateString = Format.date(DateTime(2019, 08, 1));

      expect(dateString, 'Aug 1, 2019');
    });
  });

   group('dayOfWeek', () {
     setUp(() async {
        Intl.defaultLocale = 'en_US';
         await initializeDateFormatting(Intl.defaultLocale);
    });
    test('date 2019-08-01 Day of week: Thu', () {
      final dayOfWeek = Format.dayOfWeek(DateTime(2019, 08, 1));
      expect(dayOfWeek, 'Thu');
    });
  });

  group('currency', () {
     setUp(() async {
        Intl.defaultLocale = 'en_US';
         await initializeDateFormatting(Intl.defaultLocale);
    });

    test('positive', () {
      expect(Format.currency(10), '\$10');
    });

    test('zero', () {
      expect(Format.currency(0), '');
    });

    test('negative', () {
      expect(Format.currency(-5), '-\$5');
    });

    test('decimal', () {
      expect(Format.currency(4.5), '\$5');
    });
  });

}
