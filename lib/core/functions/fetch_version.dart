import 'dart:convert';
import 'dart:io';

import 'package:app_version_update/core/utils/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import '../values/consts/consts.dart';

/// Fetch version regarding platform.
/// * ```appleId``` unique identifier in Apple Store, if null, we will use your package name.
/// * ```playStoreId``` unique identifier in Play Store, if null, we will use your package name.
/// * ```country```, region of store, if null, we will use 'us'.
Future<AppVersionData> fetchVersion({String? playStoreId, String? appleId, String? country}) async {
  final packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid){
    AppVersionData data = await fetchAndroid(
      packageInfo: packageInfo,
      playStoreId: playStoreId,
      country: country
    );
    data.localVersion = packageInfo.version;
    return data;
  } else if (Platform.isIOS){
    AppVersionData data = await fetchIOS(
      packageInfo: packageInfo,
      appleId: appleId,
      country: country
    );
    data.localVersion = packageInfo.version;
    return data;
  }
    else {
      throw "Unkown platform";
    }
}


Future<AppVersionData> fetchAndroid({PackageInfo? packageInfo, String? playStoreId, String? country}) async {
  playStoreId = playStoreId ?? packageInfo?.packageName;
  final parameters = {"id": playStoreId, "hl": country};
  var uri =
  Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);
  final response =
  await http.get(uri, headers: headers).catchError((e) => throw e);
  if (response.statusCode == 200) {
    final versionMatch =
    RegExp(r',\[\[\["([0-9,\.]*)"]],').firstMatch(response.body);
    if (versionMatch != null){
      return AppVersionData(
        storeVersion: versionMatch.group(1),
        storeUrl: uri.toString(),
        targetPlatform: TargetPlatform.android
      );
    } else {
      throw " Aplication not found in Play Store, verify your app id. ";
    }
  } else {
    throw " Aplication not found in Play Store, verify your app id. ";
  }
}

Future<AppVersionData> fetchIOS({PackageInfo? packageInfo, String? appleId, String? country}) async {
  appleId = appleId ?? packageInfo?.packageName;
  final parameters = {"id": appleId};
  var uri = Uri.https(appleStoreAuthority, '/$country/lookup', parameters);
  final response = await http.get(uri, headers: headers);
  if (response.statusCode == 200){
    final jsonResult = json.decode(response.body);
    final List results = jsonResult['results'];
    if (results.isEmpty) {
      throw " Aplication not found in Apple Store, verify your app id. ";
    } else {
      return AppVersionData(
        storeVersion: jsonResult['results'].first['version'],
        storeUrl: jsonResult['results'].first['trackViewUrl'],
        targetPlatform: TargetPlatform.iOS
      );
    }
  }
  else {
    return throw " Aplication not found in Apple Store, verify your app id. ";
  }
}

