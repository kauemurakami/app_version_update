import 'package:flutter/cupertino.dart';

/// Return of [await AppVersionUpdate.checkForUpdates()].
/// * ```storeVersion``` app version in Play Store or Apple Store.
/// * ```storeUrl``` link to update the app in its respective store
/// * ```canUpdate``` is true if exists avaible updates
/// * ```platform``` [TargetPlatform] for determine use in android or iOS
class AppVersionResult {
  AppVersionResult(
      {this.storeVersion, this.storeUrl, this.platform, this.canUpdate});
  String? storeVersion, storeUrl;
  bool? canUpdate = false;
  TargetPlatform? platform;

  then(Null Function(dynamic data) param0) {}
}
