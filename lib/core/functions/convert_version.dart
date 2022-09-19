/// Convert string of the stores for list number and compare.
/// * ```version``` local version app.
/// * ```versionStore``` store version app.
convertVersion({String? version, String? versionStore}) {
  List<String>? localVersion = [];
  List<String>? storeVersion = [];
  version!.contains('+') ? localVersion = [version.split('+').last] : null;

  localVersion.addAll(
      [version.split('.')[0], version.split('.')[1], version.split('.')[2][0]]);

  versionStore!.contains('+')
      ? storeVersion = [versionStore.split('+').last]
      : null;

  storeVersion.addAll([
    versionStore.split('.')[0],
    versionStore.split('.')[1],
    versionStore.split('.')[2][0]
  ]);

  /// Loop for verify values.
  for (int i = 0; i <= localVersion.length; i++) {
    if (int.parse(storeVersion[i]) < int.parse(localVersion[i])) {
      return false;
    }
    if (int.parse(storeVersion[i]) > int.parse(localVersion[i])) {
      return true;
    }
  }
  return false;
}
