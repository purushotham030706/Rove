import 'package:flutter_test/flutter_test.dart';
import 'package:rove_app/app.dart';
import 'package:rove_app/services/rove_repository.dart';

void main() {
  testWidgets('ROVE smoke test - checks home screen and tab navigation', (WidgetTester tester) async {
    final repo = RoveRepository(autoSync: false);

    await tester.pumpWidget(RoveApp(repository: repo));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify ROVE branding on AppBar
    expect(find.text('ROVE'), findsOneWidget);
    expect(find.text('RETRO ARCHIVE'), findsOneWidget);

    // Verify User Status Card
    expect(find.textContaining('PURU'), findsWidgets);
    expect(find.textContaining('LVL'), findsWidgets);
    expect(find.text('DISCOVERED'), findsOneWidget);

    // Verify Rarity Archive Matrix
    expect(find.text('RARITY ARCHIVE MATRIX'), findsOneWidget);
    expect(find.text('COM'), findsOneWidget);
    expect(find.text('UNC'), findsOneWidget);
    expect(find.text('RAR'), findsOneWidget);
    expect(find.text('EPI'), findsOneWidget);
    expect(find.text('LEG'), findsOneWidget);

    // Verify Capture Button
    expect(find.text('⚡ CAPTURE VEHICLE'), findsOneWidget);

    // Verify Recent Discoveries
    expect(find.text('RECENT DISCOVERIES'), findsOneWidget);

    // Test Navigation: Tap Collection Tab
    await tester.tap(find.text('COLLECTION'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('MY COLLECTION'), findsOneWidget);

    // Test Navigation: Tap Map Tab
    await tester.tap(find.text('MAP'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('DISCOVERY MAP'), findsOneWidget);

    // Test Navigation: Tap Profile Tab
    await tester.tap(find.text('PROFILE'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('ARCHIVIST PROFILE'), findsOneWidget);
    expect(find.text('FIELD CAREER STATISTICS'), findsOneWidget);

    // Test Navigation: Tap Capture Tab
    await tester.tap(find.text('CAPTURE'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('ROVE OPTICAL SCAN'), findsOneWidget);
    expect(find.text('CAPTURE PHOTO'), findsOneWidget);
  });
}
