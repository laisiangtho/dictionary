part of data.core;

abstract class _Mock extends _Abstract {
  Future<void> prepareInitialized() async {
    debugPrint('requireInitialized: ${data.requireInitialized}');
    if (data.requireInitialized) {
      Iterable<APIType> api = data.env.api.where(
        (e) => e.asset.isNotEmpty,
      );

      for (var e in api) {
        await ArchiveNest.bundle(e.asset);
      }
    }
  }
}
