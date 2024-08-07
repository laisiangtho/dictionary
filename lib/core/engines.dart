part of 'main.dart';

/// A custom data provider extended on [_Searches], [_Mocks] and [_Abstracts].
/// And private class for current project, but have access to parent data
abstract class _Engines extends _Mocks {
  // Future<void> prepareInitialized() async {}
  // Future<void> dataInitialized() async {}
  Future<void> engineInitialized() async {
    debugPrint('requireInitialized: ${data.requireInitialized}');
    if (data.requireInitialized) {
      Iterable<APIType> api = data.env.api.where(
        (e) => e.asset.isNotEmpty,
      );

      for (var e in api) {
        await Docs.archive.bundle(e.asset);
      }
    }
  }
}
