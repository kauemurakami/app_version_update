import 'dart:io';

import 'package:flutter/cupertino.dart';

class AppVersionResult {
  AppVersionResult(
      {this.storeVersion, this.storeUrl, this.platform, this.canUpdate});
  String? storeVersion, storeUrl;
  bool? canUpdate = false;
  TargetPlatform? platform;

  then(Null Function(dynamic data) param0) {}
}
