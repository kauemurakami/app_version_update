import 'dart:math';

import '../extensions/list_extensions.dart';

/// Convert string of the stores for list number and compare.
/// * ```version``` local version app.
/// * ```versionStore``` store version app.
convertVersion({String? version, String? versionStore}) {
  List<String>? localVersion = [];
  List<String>? storeVersion = [];

  /// verify version string contains + char.
  if (version!.contains('+')) {
    localVersion = [version.split('+').last];
    version = version.split('+').first;
  }

  /// add all values of array in localversion array.
  localVersion.addAll(version.split('.'));

  /// verify if exist + char in content version string.
  if (versionStore!.contains('+')) {
    storeVersion = [versionStore.split('+').last];
    versionStore = versionStore.split('+').first;
  }

  /// add all elements of array.
  storeVersion.addAll(versionStore.split('.'));

  /// Loop for verify values.
  var maxLength = max(localVersion.length, storeVersion.length);
  for (int i = 0; i < maxLength; i++) {
    /// if any of the store elements is smaller than a corresponding element of local version we will exit the function with false.
    if (int.parse(storeVersion.getOrDefault(i, '0')) <
        int.parse(localVersion.getOrDefault(i, '0'))) {
      return false;
    }

    /// if any element of the store version is greater than the corresponding local version, there is an update.
    if (int.parse(storeVersion.getOrDefault(i, '0')) >
        int.parse(localVersion.getOrDefault(i, '0'))) {
      return true;
    }
  }

  /// default false
  return false;
}
