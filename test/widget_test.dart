import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intro_to_genui/main.dart';

import 'fake_quiz_transport.dart';

void main() {
  testWidgets('home shows start and navigates to quiz route', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      TemperamentQuestApp(quizTransport: FakeQuizTransport()),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Start the quiz'), findsOneWidget);
    await tester.tap(find.text('Start the quiz'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Question 1 of'), findsOneWidget);
  });
}
