/// Convert string of the stores for list number and compare.
/// * ```version``` local version app.
/// * ```versionStore``` store version app.
convertVersion({String? version, String? versionStore}) {
  List<String>? localVersion = [];
  List<String>? storeVersion = [];

  /// verify version string contains + char.
  if (version!.contains('+')) {
    localVersion = [version.split('+').last];
  }

  /// add all values of array in localversion array.
  localVersion.addAll(
      [version.split('.')[0], version.split('.')[1], version.split('.')[2][0]]);

  /// verify if exist + char in content version string.
  if (versionStore!.contains('+')) {
    storeVersion = [versionStore.split('+').last];
  }

  /// add all elements of array.
  storeVersion.addAll([
    versionStore.split('.')[0],
    versionStore.split('.')[1],
    versionStore.split('.')[2][0]
  ]);

  /// Loop for verify values.
  for (int i = 0; i < localVersion.length; i++) {
    /// if any of the store elements is smaller than a corresponding element of local version we will exit the function with false.
    if (int.parse(storeVersion[i]) < int.parse(localVersion[i])) {
      return false;
    }

    /// if any element of the store version is greater than the corresponding local version, there is an update.
    if (int.parse(storeVersion[i]) > int.parse(localVersion[i])) {
      return true;
    }
  }

  /// default false
  return false;
}
