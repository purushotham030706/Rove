import 'package:flutter_test/flutter_test.dart';
import 'package:rove_app/app.dart';
import 'package:rove_app/services/rove_repository.dart';
import 'package:rove_app/core/branding/branding.dart';

void main() {
  testWidgets('Core Capture to Discovery Reveal flow test', (WidgetTester tester) async {
    final repo = RoveRepository(autoSync: false);

    await tester.pumpWidget(RoveApp(repository: repo));
    await tester.pump(const Duration(milliseconds: 100));

    // Navigate to Capture screen
    await tester.tap(find.text('CAPTURE'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify viewfinder
    expect(find.text('ROVE OPTICAL SCAN'), findsOneWidget);
    expect(find.text('CAPTURE PHOTO'), findsOneWidget);

    // Tap Capture button to capture vehicle
    await tester.tap(find.text('CAPTURE PHOTO'));
    await tester.pump(const Duration(milliseconds: 100));

    // Wait for simulated neural latency
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 200));

    // Should arrive on Discovery Reveal screen
    expect(find.text('INSPECT FULL SPECIFICATIONS'), findsOneWidget);
    expect(find.text('RETURN TO HOME'), findsOneWidget);

    // Navigate to Vehicle Detail screen
    await tester.tap(find.text('INSPECT FULL SPECIFICATIONS'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Vehicle Detail
    expect(find.text('HEADLINE PERFORMANCE METRICS'), findsOneWidget);
    expect(find.text('TECHNICAL BLUEPRINT'), findsOneWidget);
    expect(find.text('AUTOMOTIVE LORE & HERITAGE'), findsOneWidget);
  });

  testWidgets('Rarity tier model and XP tests', (WidgetTester tester) async {
    expect(RarityTier.common.baseXP, 10);
    expect(RarityTier.uncommon.baseXP, 25);
    expect(RarityTier.rare.baseXP, 50);
    expect(RarityTier.epic.baseXP, 100);
    expect(RarityTier.legendary.baseXP, 250);
    expect(RarityTier.mythic.baseXP, 500);

    expect(RarityTier.fromString('RARE'), RarityTier.rare);
    expect(RarityTier.fromString('EPIC'), RarityTier.epic);
    expect(RarityTier.fromString('UNKNOWN_TIER'), RarityTier.common);
  });
}
