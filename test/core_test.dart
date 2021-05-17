import 'package:flutter_test/flutter_test.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/services.dart';
// import 'package:dictionary/core.dart';
import 'package:lidea/engine.dart';

void main() async{

  TestWidgetsFlutterBinding.ensureInitialized();


  // testWidgets('Example', (tester) async {
  //   // BinaryMessages.setMockMessageHandler
  //   await tester.runAsync(() async {
  //     ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) {
  //       // The key is the asset key.
  //       String key = utf8.decode(message.buffer.asUint8List());
  //       // Manually load the file.
  //       print('../$key');
  //       var file = new File('../$key');
  //       final Uint8List encoded = utf8.encoder.convert(file.readAsStringSync());
  //       return Future.value(encoded.buffer.asByteData());
  //     });
  //     // continue your test, now your widget should be able to load the asset
  //     final core = Core();
  //     await core.init();
  //   });
  // });

  test('Core', () async{
    // final core = Core();
    // await core.init();
    final env = await UtilDocument.loadBundleAsString('env.json');
    print(env);
    // await core.mockCheckDatabaseFiles();
    expect("ab", "ab");
  });
  // testWidgets('TestName"', (WidgetTester tester) async {
  //   // final core = Core();
  //   // await core.init();
  //   final env = await UtilDocument.loadBundleAsString('env.json');
  //   print(env);
  //   // await core.mockCheckDatabaseFiles();
  //   expect("ab", "ab");
  // });
}
