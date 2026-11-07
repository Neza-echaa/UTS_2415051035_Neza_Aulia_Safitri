import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_mate/main.dart';

void main() {
  testWidgets('RecipeMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeMateApp());

    expect(find.text('RecipeMate'), findsOneWidget);
  });
}