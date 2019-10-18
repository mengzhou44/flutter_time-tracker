import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/common_widgets/custom-raised-button.dart';

void main() {
  testWidgets("onPressed callback", (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CustomRaisedButton(
            child: Text('tap me!'), onPressed: () => pressed = true),
      ),
    );
    final button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    await tester.tap(button);

    expect(pressed, true);

  });
} 