import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_golden_test/main.dart';

Future<void> _loadFont(String name, String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();

  final fontLoader = FontLoader(name);
  fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));

  await fontLoader.load();
}

void main() {
  setUpAll(() async {
    await _loadFont(
      '.SF UI Text',
      'test/fonts/FontsFree-Net-sf-ui-text-regular-58646b56a688c.ttf',
    );
    await _loadFont(
      '.SF UI Display',
      'test/fonts/FontsFree-Net-SF-UI-Display-Regular-1.ttf',
    );
    await _loadFont(
      'MaterialIcons',
      'test/fonts/MaterialIcons-Regular.otf',
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Size and dead zone found on
    // https://useyourloaf.com/blog/iphone-14-screen-sizes/
    tester.view.physicalSize = const Size(1170, 2532 - 47 * 3 - 34 * 3);

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    // Uncomment to render shadow, but can cause false positive.
    //debugDisableShadows = false;

    await tester.pumpWidget(const MyApp());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('home_page.png'),
    );

    debugDefaultTargetPlatformOverride = null;
    //debugDisableShadows = true;
  });
}
