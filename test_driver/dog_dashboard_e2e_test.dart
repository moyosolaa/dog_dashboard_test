import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Dog Image Dashboard E2E Test', () {
    late final FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('Check if the app starts correctly', () async {
      // Verify that the Dog Image Dashboard title is displayed
      final titleFinder = find.text('Dog Image Dashboard');
      await driver.waitFor(titleFinder);
    });

    test('Tap the "Get Random Dog Image" button', () async {
      // Find and tap the "Get Random Dog Image" button
      final randomDogButtonFinder = find.text('Get Random Dog Image');
      await driver.tap(randomDogButtonFinder);

      // Verify that the loading spinner or a random dog image is displayed
      final loadingSpinnerFinder = find.byType('CircularProgressIndicator');
      final randomDogImageFinder = find.byType('CachedNetworkImage');
      await driver.waitFor(loadingSpinnerFinder);
      await driver.waitFor(randomDogImageFinder);
    });
  });
}
