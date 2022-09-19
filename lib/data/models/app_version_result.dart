import 'package:flutter/cupertino.dart';

/// Return of [await AppVersionUpdate.checkForUpdates()].
/// * __[storeVersion]__ app version in Play Store or Apple Store.
/// * __[storeUrl]__ link to update the app in its respective store
/// * __[canUpdate]__ is true if exists avaible updates
/// * __[platform]__ [TargetPlatform] for determine use in android or iOS
class AppVersionResult {
  AppVersionResult(
      {this.storeVersion, this.storeUrl, this.platform, this.canUpdate});
  String? storeVersion, storeUrl;
  bool? canUpdate = false;
  TargetPlatform? platform;

  then(Null Function(dynamic data) param0) {}
}
