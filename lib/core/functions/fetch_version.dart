import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import '../values/consts/consts.dart';

/// Fetch version regarding platform.
/// * ```appleId``` unique identifier in Apple Store, if null, we will use your package name.
/// * ```playStoreId``` unique identifier in Play Store, if null, we will use your package name.
/// * ```country```, region of store, if null, we will use 'us'.
Future<List<dynamic>> fetchVersion({String? playStoreId, String? appleId, String? country}) async {
  final packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid){
    List result = await fetchAndroid(
      packageInfo: packageInfo,
      playStoreId: playStoreId,
      country: country
    );
    result.insert(0, packageInfo.version);
    return result;
  } else if (Platform.isIOS){
    List result = await fetchIOS(
      packageInfo: packageInfo,
      appleId: appleId,
      country: country
    );
    result.insert(0, packageInfo.version);
    return result;
  }
    else {
      throw "Unkown platform";
    }
}


Future<List<dynamic>> fetchAndroid({PackageInfo? packageInfo, String? playStoreId, String? country}) async {
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
      return [versionMatch.group(1),uri.toString(),TargetPlatform.android];
    } else {
      throw " Aplication not found in Play Store, verify your app id. ";
    }
  } else {
    throw " Aplication not found in Play Store, verify your app id. ";
  }
}

Future<List<dynamic>> fetchIOS({PackageInfo? packageInfo, String? appleId, String? country}) async {
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
      return [jsonResult['results'].first['version'],jsonResult['results'].first['trackViewUrl'],TargetPlatform.iOS];
    }
  }
  else {
    return throw " Aplication not found in Apple Store, verify your app id. ";
  }
}

