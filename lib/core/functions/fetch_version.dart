import 'dart:convert';
import 'dart:io';

import 'package:app_version_update/data/models/app_version_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import '../values/consts/consts.dart';
import 'convert_version.dart';

/// Fetch version regarding platform.
/// * ```appleId``` unique identifier in Apple Store, if null, we will use your package name.
/// * ```playStoreId``` unique identifier in Play Store, if null, we will use your package name.
/// * ```country```, region of store, if null, we will use 'us'.
Future<AppVersionData> fetchVersion(
    {String? playStoreId, String? appleId, String? country}) async {
  final packageInfo = await PackageInfo.fromPlatform();
  AppVersionData data = AppVersionData();
  if (Platform.isAndroid) {
    data = await fetchAndroid(
        packageInfo: packageInfo, playStoreId: playStoreId, country: country);
  } else if (Platform.isIOS) {
    data = await fetchIOS(
        packageInfo: packageInfo, appleId: appleId, country: country);
  } else {
    throw "Unkown platform";
  }
  data.canUpdate = await convertVersion(
      version: data.localVersion, versionStore: data.storeVersion);
  return data;
}

Future<AppVersionData> fetchAndroid(
    {PackageInfo? packageInfo, String? playStoreId, String? country}) async {
  playStoreId = playStoreId ?? packageInfo?.packageName;
  final parameters = {"id": playStoreId, "hl": country};
  var uri = Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);
  final response =
      await http.get(uri, headers: headers).catchError((e) => throw e);
  if (response.statusCode == 200) {
    final versionMatch =
        RegExp(r',\[\[\["([0-9,\.]*)"]],').firstMatch(response.body);
    if (versionMatch != null) {
      return AppVersionData(
          storeVersion: versionMatch.group(1),
          storeUrl: uri.toString(),
          localVersion: packageInfo?.version,
          targetPlatform: TargetPlatform.android,
          );
    } else {
      throw " Aplication not found in Play Store, verify your app id. ";
    }
  } else {
    throw " Aplication not found in Play Store, verify your app id. ";
  }
}

Future<AppVersionData> fetchIOS(
    {PackageInfo? packageInfo, String? appleId, String? country}) async {
  assert(appleId != null || packageInfo != null,
      'One between appleId or packageInfo must not be null');
  var parameters = (appleId != null) ? {"id": appleId} : {'bundleId': packageInfo?.packageName};
  if (country != null) {
    parameters['country'] = country;
  }
  var uri = Uri.https(appleStoreAuthority, '/lookup', parameters);
  final response = await http.get(uri, headers: headers);
  if (response.statusCode == 200) {
    final jsonResult = json.decode(response.body);
    final List results = jsonResult['results'];
    if (results.isEmpty) {
      throw " Aplication not found in Apple Store, verify your app id. ";
    } else {
      return AppVersionData(
          storeVersion: jsonResult['results'].first['version'],
          storeUrl: jsonResult['results'].first['trackViewUrl'],
          localVersion: packageInfo?.version,
          targetPlatform: TargetPlatform.iOS);
    }
  } else {
    return throw " Aplication not found in Apple Store, verify your app id. ";
  }
}
