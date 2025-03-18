import 'package:flutter/foundation.dart';

class AppVersionData {
  String? localVersion;
  String? storeVersion;
  String? storeUrl;
  TargetPlatform? targetPlatform;
  bool? canUpdate;

  AppVersionData(
      {this.localVersion,
      this.storeVersion,
      this.storeUrl,
      this.targetPlatform,
      this.canUpdate = false});
}
