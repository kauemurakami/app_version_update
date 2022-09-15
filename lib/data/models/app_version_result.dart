import 'dart:io';

import 'package:flutter/cupertino.dart';

class AppVersionResult {
  AppVersionResult({this.storeVersion, this.storeUrl, this.platform});
  String? storeVersion, storeUrl;
  TargetPlatform? platform;

  then(Null Function(dynamic data) param0) {}
}
