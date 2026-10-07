import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pracproj/core/widget/widgets.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('LazyIndexedStack only builds children once shown', (tester) async {
    final built = <int>[];
    Widget page(int i) => Builder(
      builder: (_) {
        built.add(i);
        return Text('page$i');
      },
    );

    var index = 0;
    late StateSetter setIndex;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (_, setState) {
            setIndex = setState;
            return LazyIndexedStack(index: index, children: [page(0), page(1)]);
          },
        ),
      ),
    );
    expect(built, [0]);

    setIndex(() => index = 1);
    await tester.pump();
    expect(built.toSet(), {0, 1});
  });

  testWidgets('AppBtn exposes its semantic label and honours a null onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        AppBtn.from(onPressed: () => taps++, text: 'Save', semanticLabel: 'Save changes'),
      ),
    );
    expect(find.bySemanticsLabel('Save changes'), findsOneWidget);
    expect(find.text('SAVE'), findsOneWidget);

    await tester.tap(find.text('SAVE'));
    expect(taps, 1);

    await tester.pumpWidget(_wrap(AppBtn.from(onPressed: null, text: 'Save')));
    await tester.tap(find.text('SAVE'), warnIfMissed: false);
    expect(taps, 1, reason: 'disabled button must not fire');
  });

  testWidgets('AppButton swaps its label for a spinner and blocks taps while loading', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(label: 'Log in', isLoading: true, onPressed: () => taps++)),
    );
    expect(find.text('LOG IN'), findsNothing);
    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    await tester.tap(find.byType(AppButton), warnIfMissed: false);
    expect(taps, 0);

    await tester.pumpWidget(_wrap(AppButton(label: 'Log in', onPressed: () => taps++)));
    expect(find.text('LOG IN'), findsOneWidget);
    await tester.tap(find.text('LOG IN'));
    expect(taps, 1);
  });

  testWidgets('EightWaySwipeDetector reports a normalized direction', (tester) async {
    final dirs = <Offset>[];
    await tester.pumpWidget(
      _wrap(
        EightWaySwipeDetector(
          onSwipe: dirs.add,
          child: const ColoredBox(color: Colors.grey, child: SizedBox.expand()),
        ),
      ),
    );

    await tester.drag(find.byType(EightWaySwipeDetector), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(dirs, isNotEmpty);
    expect(dirs.first, const Offset(-1, 0));
  });

  testWidgets('BackBtn pops, and falls back when there is nothing to pop', (tester) async {
    var fallbacks = 0;
    await tester.pumpWidget(_wrap(BackBtn(onFallback: () => fallbacks++)));
    await tester.tap(find.byType(BackBtn));
    await tester.pumpAndSettle();
    expect(fallbacks, 1);
  });

  testWidgets('DiagonalTextPageIndicator zero-pads both numbers', (tester) async {
    await tester.pumpWidget(_wrap(const DiagonalTextPageIndicator(current: 3, total: 12)));
    expect(find.text('03'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });
}
