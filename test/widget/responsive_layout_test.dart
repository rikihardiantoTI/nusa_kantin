import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kantin/main.dart';

void main() {
  group('NusaKantin Responsive Layout & Accessibility Tests', () {
    testWidgets('Compact (< 600): menampilkan NavigationBar dan ListView', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const NusaKantinApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(ListView), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Medium & Expanded (>= 600): menampilkan NavigationRail, GridView, dan Panel Detail',
      (tester) async {
        tester.view.physicalSize = const Size(900, 700);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const NusaKantinApp());
        await tester.pumpAndSettle();

        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);
        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Deskripsi Menu'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('HP Landscape tanpa overflow pada Menu dan Pesanan', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const NusaKantinApp());
      await tester.pumpAndSettle();

      // Tambah satu item ke pesanan
      final addButton = find.byIcon(Icons.add_shopping_cart).first;
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Pindah ke tab Pesanan
      await tester.tap(find.text('Pesanan'));
      await tester.pumpAndSettle();

      expect(find.text('Ringkasan Pesanan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Skala teks 200% (TextScaler.linear(2.0)) tanpa overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(2.0),
          ),
          child: NusaKantinApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Tambah pesanan dan buka tab Pesanan pada skala teks 200%
      final orderButton = find.text('Pesan').first;
      await tester.ensureVisible(orderButton);
      await tester.pumpAndSettle();
      await tester.tap(orderButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pesanan'));
      await tester.pumpAndSettle();

      expect(find.text('Ringkasan Pesanan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
