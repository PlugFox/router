import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:octopus_example/src/common/initialization/initialization.dart';
import 'package:octopus_example/src/common/router/screens.dart';
import 'package:octopus_example/src/common/widget/app.dart';

import 'src/util/async_finder.dart';

void main() {
  // ignore: unused_local_variable
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end_tests', () {
    setUp(() async {
      await $initializeApp();
    });

    tearDown(() async {
      await $disposeApp();
    });

    testWidgets('App', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const App());
      await asyncFinder(tester: tester, finder: () => find.byType(App));

      // Check initial state.
      expect(find.byType(App), findsOneWidget);
      expect(find.byType(ShopScreen), findsOneWidget);
      expect(find.text('Shop'), findsAtLeastNWidgets(1));
    });
  });
}
