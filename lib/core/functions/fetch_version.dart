import 'dart:convert';
import 'dart:io';

import 'package:app_version_update/data/models/app_version_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../values/consts/consts.dart';
import 'convert_version.dart';

/// Fetch version regarding platform.
/// * ```appleId``` unique identifier in Apple Store, if null, we will use your package name.
/// * ```playStoreId``` unique identifier in Play Store, if null, we will use your package name.
/// * ```country``` (iOS only) region of store, if null, we will use 'us'.
Future<AppVersionData> fetchVersion(
    {String? playStoreId, String? appleId, String? country}) async {
  final packageInfo = await PackageInfo.fromPlatform();
  AppVersionData data = AppVersionData();
  if (Platform.isAndroid) {
    data =
        await fetchAndroid(packageInfo: packageInfo, playStoreId: playStoreId);
  } else if (Platform.isIOS) {
    data = await fetchIOS(
      packageInfo: packageInfo,
      appleId: appleId,
      country: country,
    );
  } else {
    throw "Unknown platform";
  }
  data.canUpdate = await convertVersion(
      version: data.localVersion, versionStore: data.storeVersion);
  return data;
}

Future<AppVersionData> fetchAndroid(
    {PackageInfo? packageInfo, String? playStoreId}) async {
  playStoreId = playStoreId ?? packageInfo?.packageName;
  final parameters = {
    "id": playStoreId,
  };
  var uri = Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);
  final response =
      await http.get(uri, headers: headers).catchError((e) => throw e);
  if (response.statusCode == 200) {
    final String htmlString = response.body;
    RegExp regex;
    Iterable<RegExpMatch> matches = [];
    if (htmlString.contains('null,[[["')) {
      regex = RegExp(r'null,\[\[\["([\d\.]+)"\]\]\]');
      matches = regex.allMatches(htmlString);
    }

    if (matches.isEmpty && htmlString.contains('Version')) {
      regex = RegExp(r'<div itemprop="description">Version ([\d\.]+)<br>');
      matches = regex.allMatches(htmlString);
    }

    if (matches.isEmpty && htmlString.contains('version')) {
      regex = RegExp(r'(\d+\.\d+\.\d+)');
      matches = regex.allMatches(htmlString);
    }

    if (matches.isEmpty) {
      regex = RegExp(r'"\]\]\],"(.*?)"');
      matches = regex.allMatches(htmlString);
    }

    if (matches.isNotEmpty) {
      // matchList.sort((a, b) {
      //   String versionA = a.group(1)!;
      //   String versionB = b.group(1)!;

      //   // Ignora a versão "24.04.47" durante a comparação
      //   if (versionA == '24.04.47') return 1; // Coloca a versão "24.04.47" depois
      //   if (versionB == '24.04.47') return -1; // Coloca a versão "24.04.47" depois

      //   List<int> versionToList(String version) {
      //     return version.split('.').map((part) => int.parse(part)).toList();
      //   }

      //   List<int> listA = versionToList(versionA);
      //   List<int> listB = versionToList(versionB);

      //   for (int i = 0; i < listA.length; i++) {
      //     if (listA[i] > listB[i]) return -1;
      //     if (listA[i] < listB[i]) return 1;
      //   }
      //   return 0;
      // });

      // Agora, 'matchList' tem a versão mais recente no início
      // Remover todos os matches exceto o primeiro (o mais recente)
      // matches = [matchList.first];

      final lastMatch = matches.last;
      String? lastVersion = lastMatch.group(1);
      lastVersion = lastVersion!.split('"').first;
      if (kDebugMode) {
        print(
          'Local version ${packageInfo!.version} Store version: $lastVersion',
        );
      }
      return AppVersionData(
        // canUpdate: packageInfo.version < lastVersion ? true : false,
        storeVersion: lastVersion,
        storeUrl: uri.toString(),
        localVersion: packageInfo!.version,
        targetPlatform: TargetPlatform.android,
      );
    } else {
      throw "Application not found in Play Store, verify your app id.";
    }
  } else {
    throw "Application not found in Play Store, verify your app id.";
  }
}

Future<AppVersionData> fetchIOS(
    {PackageInfo? packageInfo, String? appleId, String? country}) async {
  assert(appleId != null || packageInfo != null,
      'One between appleId or packageInfo must not be null');
  var parameters = (appleId != null)
      ? {"id": appleId}
      : {'bundleId': packageInfo?.packageName};
  if (country != null) {
    parameters['country'] = country;
  }
  parameters['version'] = '2';
  var uri = Uri.https(appleStoreAuthority, '/lookup', parameters);
  final response = await http.get(uri, headers: headers);
  if (response.statusCode == 200) {
    final jsonResult = json.decode(response.body);
    final List results = jsonResult['results'];
    if (results.isEmpty) {
      throw "Application not found in Apple Store, verify your app id.";
    } else {
      return AppVersionData(
          storeVersion: jsonResult['results'].first['version'],
          storeUrl: jsonResult['results'].first['trackViewUrl'],
          localVersion: packageInfo?.version,
          targetPlatform: TargetPlatform.iOS);
    }
  } else {
    return throw "Application not found in Apple Store, verify your app id.";
  }
}
