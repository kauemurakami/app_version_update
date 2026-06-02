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

Future<AppVersionData> fetchAndroid({
  PackageInfo? packageInfo,
  String? playStoreId,
}) async {
  playStoreId = playStoreId ?? packageInfo?.packageName;

  final parameters = {"id": playStoreId};
  // DICA: Forçar o local 'en' ajuda a manter a estrutura do HTML previsível
  var uri = Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);

  final response =
      await http.get(uri, headers: headers).catchError((e) => throw e);

  if (response.statusCode == 200) {
    final String htmlString = response.body;

    // 1. Regex ultra-focado: captura qualquer string de versão que esteja isolada por aspas
    // dentro dos blocos de dados, suportando formatos normais (1.0.2) e Meta/Facebook (563.1.0.50.73)
    final RegExp versionRegex = RegExp(r'"(\d+\.\d+\.\d+[^"]*)"');
    final matches = versionRegex.allMatches(htmlString);

    if (matches.isNotEmpty) {
      List<String> detectedVersions = [];

      for (var match in matches) {
        String version = match.group(1)!;

        // Filtros para evitar pegar IDs grandes, datas ou strings com letras perdidas
        if (version.length < 18 &&
            !version.contains(',') &&
            !version.contains('/') &&
            RegExp(r'^\d').hasMatch(version)) {
          // Garante que começa com número
          detectedVersions.add(version);
        }
      }

      if (detectedVersions.isNotEmpty) {
        // A versão do app costuma aparecer primeiro ou repetidas vezes no bloco de metadados.
        // Se a primeira falhar no seu teste, você pode testar detectedVersions[1] ou [2]
        String lastVersion = detectedVersions.first;

        return AppVersionData(
          storeVersion: lastVersion,
          storeUrl: uri.toString(),
          localVersion: packageInfo?.version ?? "0.0.0",
          targetPlatform: TargetPlatform.android,
        );
      }
    }

    // 2. Fallback multilíngue (independe se está em inglês, português ou espanhol)
    final fallbackRegex =
        RegExp(r'(?:version|versão|versión).*?([\d\.]+)', caseSensitive: false);
    final fallbackMatch = fallbackRegex.firstMatch(htmlString);

    if (fallbackMatch != null) {
      return AppVersionData(
        storeVersion: fallbackMatch.group(1)!,
        storeUrl: uri.toString(),
        localVersion: packageInfo?.version ?? "0.0.0",
        targetPlatform: TargetPlatform.android,
      );
    }

    throw "Application not found in Play Store or layout changed, verify your app id.";
  } else {
    throw "Application not found in Play Store, verify your app id. Status: ${response.statusCode}";
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
