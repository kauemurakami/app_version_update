library app_version_update;

import 'dart:convert';
import 'dart:io';
import 'package:app_version_update/data/models/app_version_error.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'core/values/consts/consts.dart';

class AppVersionUpdate {
  static Future<AppVersionResult> checkForUpdates(
      {String? appleId, String? playStoreId, String? country = 'us'}) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      playStoreId = playStoreId ?? packageInfo.packageName;
      final parameters = {id: playStoreId, "hl": country};
      var uri =
          Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode != 200) {
        return AppVersionResult(storeUrl: null, storeVersion: null);
      } else {
        return AppVersionResult(
            storeUrl: uri.toString(),
            storeVersion: RegExp(r',\[\[\["([0-9,\.]*)"]],')
                .firstMatch(response.body)!
                .group(1),
            platform: TargetPlatform.android);
      }
    } else {
      appleId = appleId ?? packageInfo.packageName;
      final parameters = {id: appleId};
      var uri = Uri.https(appleStoreAuthority, '/$country/lookup', parameters);
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        return AppVersionResult(storeUrl: null, storeVersion: null);
      }
      final jsonObj = json.decode(response.body);
      final List results = jsonObj['results'];
      if (results.isEmpty) {
        return AppVersionResult(storeUrl: null, storeVersion: null);
      }
      return AppVersionResult(
          storeUrl: jsonObj['results'].first['trackViewUrl'],
          storeVersion: jsonObj['results'].first['version'],
          platform: TargetPlatform.iOS);
    }
  }
}
