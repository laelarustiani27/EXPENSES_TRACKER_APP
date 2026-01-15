import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/widgets/circular_logo.dart';

void main() {
  group('CircularLogo Widget Tests', () {
    testWidgets(
      'CircularLogo displays as perfect circle with correct properties',
      (WidgetTester tester) async {
        const testAssetPath = 'assets/icons/appstore.png';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularLogo(assetPath: testAssetPath)),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the CircularLogo widget
        final circularLogoFinder = find.byType(CircularLogo);
        expect(circularLogoFinder, findsOneWidget);

        // Find the Container inside CircularLogo
        final containerFinder = find.descendant(
          of: circularLogoFinder,
          matching: find.byType(Container),
        );
        expect(containerFinder, findsOneWidget);

        final containerWidget = tester.widget<Container>(containerFinder);
        
        // Check if it's a BoxDecoration
        expect(containerWidget.decoration, isA<BoxDecoration>());

        final decoration = containerWidget.decoration as BoxDecoration;
        
        // Verify circle shape
        expect(decoration.shape, BoxShape.circle);
        expect(decoration.color, Colors.white);
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, 1);

        // Find ClipOval
        final clipOvalFinder = find.descendant(
          of: circularLogoFinder,
          matching: find.byType(ClipOval),
        );
        expect(clipOvalFinder, findsOneWidget);

        // Find Image
        final imageFinder = find.descendant(
          of: clipOvalFinder,
          matching: find.byType(Image),
        );
        expect(imageFinder, findsOneWidget);

        final imageWidget = tester.widget<Image>(imageFinder);
        expect(imageWidget.fit, BoxFit.cover);
        expect((imageWidget.image as AssetImage).assetName, testAssetPath);
      },
    );

    testWidgets('CircularLogo has correct default size', (
      WidgetTester tester,
    ) async {
      const testAssetPath = 'assets/icons/appstore.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularLogo(assetPath: testAssetPath)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final circularLogoFinder = find.byType(CircularLogo);
      final containerFinder = find.descendant(
        of: circularLogoFinder,
        matching: find.byType(Container),
      );
      
      final containerWidget = tester.widget<Container>(containerFinder);
      
      // Check default size (60.0)
      expect(containerWidget.constraints?.maxWidth, 60.0);
      expect(containerWidget.constraints?.maxHeight, 60.0);
    });

    testWidgets('CircularLogo accepts custom size', (
      WidgetTester tester,
    ) async {
      const testAssetPath = 'assets/icons/appstore.png';
      const customSize = 150.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularLogo(
                assetPath: testAssetPath,
                size: customSize,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final circularLogoFinder = find.byType(CircularLogo);
      final containerFinder = find.descendant(
        of: circularLogoFinder,
        matching: find.byType(Container),
      );
      
      final containerWidget = tester.widget<Container>(containerFinder);

      expect(containerWidget.constraints?.maxWidth, customSize);
      expect(containerWidget.constraints?.maxHeight, customSize);
    });

    testWidgets('CircularLogo is easy to replace with different asset', (
      WidgetTester tester,
    ) async {
      const newAssetPath = 'assets/icons/kipas.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularLogo(assetPath: newAssetPath)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      final imageWidget = tester.widget<Image>(imageFinder);

      expect((imageWidget.image as AssetImage).assetName, newAssetPath);
    });

    testWidgets('CircularLogo renders without errors', (
      WidgetTester tester,
    ) async {
      const testAssetPath = 'assets/icons/appstore.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularLogo(assetPath: testAssetPath),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}