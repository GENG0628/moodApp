import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mood_app/app/app.dart';

void main() {
  testWidgets('shows the main mood app tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodApp());

    expect(find.text('心情记录'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
  });

  testWidgets('can open the mood editor', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodApp());

    await tester.tap(find.byIcon(Icons.edit_note));
    await tester.pumpAndSettle();

    expect(find.text('记录此刻心情'), findsOneWidget);
    expect(find.text('保存记录'), findsOneWidget);
  });
}
