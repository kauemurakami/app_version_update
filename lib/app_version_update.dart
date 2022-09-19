library app_version_update;

import 'dart:convert';
import 'dart:io';
import 'package:app_version_update/core/functions/convert_version.dart';
import 'package:app_version_update/data/enums/app_version_widgets.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:app_version_update/widgets/alert_dialog_update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'core/values/consts/consts.dart';

class AppVersionUpdate {
  /// Checks for app update in stores, taking into account the local version.
  /// * ```appleId``` unique identifier in Apple Store, if null, we will use your package name.
  /// * ```playStoreId``` unique identifier in Play Store, if null, we will use your package name.
  /// * ```country```, region of store, if null, we will use 'us'.
  /// ## example
  /// ```dart
  /// await AppVersionUpdate.checkForUpdates(
  ///   appleId: '123456789',
  ///   playStoreId: 'com.example.app',
  ///   country: 'br')
  /// .then((data) async {
  ///    if (data.canUpdate!) {
  ///       //action...
  ///     });
  /// ```
  static Future<AppVersionResult> checkForUpdates({
    String? appleId,
    String? playStoreId,
    String? country = 'us',
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      playStoreId = playStoreId ?? packageInfo.packageName;
      final parameters = {id: playStoreId, "hl": country};
      var uri =
          Uri.https(playStoreAuthority, playStoreUndecodedPath, parameters);
      final response =
          await http.get(uri, headers: headers).catchError((e) => throw e);
      AppVersionResult appVersionResult = AppVersionResult(
          canUpdate: convertVersion(
              version: packageInfo.version,
              versionStore: RegExp(r',\[\[\["([0-9,\.]*)"]],')
                  .firstMatch(response.body)!
                  .group(1)!),
          storeUrl: uri.toString(),
          storeVersion: RegExp(r',\[\[\["([0-9,\.]*)"]],')
              .firstMatch(response.body)!
              .group(1),
          platform: TargetPlatform.android);
      if (response.statusCode != 200) {
        throw " Aplication not found in Play Store, verify your app id. ";
      }
      return appVersionResult;
    } else {
      appleId = appleId ?? packageInfo.packageName;
      final parameters = {id: appleId};
      var uri = Uri.https(appleStoreAuthority, '/$country/lookup', parameters);
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        return throw " Aplication not found in Apple Store, verify your app id. ";
      }
      final jsonResult = json.decode(response.body);
      final List results = jsonResult['results'];
      final appVersionResult = AppVersionResult(
          canUpdate: convertVersion(
              version: packageInfo.version,
              versionStore: jsonResult['results'].first['version']),
          storeUrl: jsonResult['results'].first['trackViewUrl'],
          storeVersion: jsonResult['results'].first['version'],
          platform: TargetPlatform.iOS);
      if (results.isEmpty) {
        throw " Aplication not found in Apple Store, verify your app id. ";
      }
      return appVersionResult;
    }
  }

  /// Displays an alert dialog for the user to decide whether to enter update now or update later.
  /// * ```appVersionResult``` result of [AppVersionUpdate.checkForUpdate()].
  /// * ```context``` build context.
  /// * ```backgroundColor``` background color dialog.
  /// * ```title``` text title.
  /// * ```content``` text content.
  /// * ```updateButtonText``` update button text.
  /// * ```cancelButtonText``` cancel button text.
  /// * ```titleTextStyle``` text style for title.
  /// * ```contentTextStyle``` text style for body content.
  /// * ```updateTextStyle``` text style for text update button.
  /// * ```cancelTextStyle``` text style for text cancel button.
  /// * ```updateButtonStyle``` style of update button.
  /// * ```cancelButtonStyle``` style of cancel button.
  /// * ```modalType``` not yet available, but it will serve as a decision for the type of widget provided by us for display.
  /// ## example
  /// ```dart
  /// await AppVersionUpdate.showAlertUpdate(
  ///        appVersionResult: data,
  ///        context: context,
  ///        backgroundColor: Colors.red,
  ///        title: 'Title.',
  ///        content:
  ///            'Body content',
  ///        updateButtonText: 'UPDATE',
  ///        cancelButtonText: 'UPDATE LATER',
  ///        titleTextStyle: TextStyle(color: Colors.black, fontSize: 16.0),
  ///        contentTextStyle: TextStyle(color: Colors.black),
  ///      );
  /// ```
  static showAlertUpdate({
    @required AppVersionResult? appVersionResult,
    @required BuildContext? context,
    String? title = 'New version available',
    String? content = 'Would you like to update your application?',
    String? cancelButtonText = 'Update later',
    String? updateButtonText = 'Update',
    ShowModalType? modalType = ShowModalType.alert_dialog,
    Color? backgroundColor = Colors.white,
    TextStyle? cancelTextStyle = const TextStyle(color: Colors.red),
    TextStyle? updateTextStyle = const TextStyle(color: Colors.green),
    TextStyle? titleTextStyle =
        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
    TextStyle? contentTextStyle,
    ButtonStyle? cancelButtonStyle,
    ButtonStyle? updateButtonStyle,
  }) async {
    if (modalType == ShowModalType.alert_dialog) {
      await showDialog(
          context: context!,
          builder: (context) => UpdateVersionDialog(
                appVersionResult: appVersionResult,
                title: title,
                titleTextStyle: titleTextStyle,
                content: content,
                cancelTextStyle: cancelTextStyle,
                updateTextStyle: updateTextStyle,
                contentTextStyle: contentTextStyle,
                backgroundColor: backgroundColor,
                cancelButtonText: cancelButtonText,
                cancelButtonStyle: cancelButtonStyle,
                updateButtonText: updateButtonText,
                updateButtonStyle: updateButtonStyle,
              ));
    } else if (modalType == ShowModalType.page) {
      throw "available soon";
      // Navigator.push(context!,
      //     MaterialPageRoute(builder: (context) => const UpdateVersionPage()));
    } else if (modalType == ShowModalType.bottom_sheet) {
      throw "available soon";
    }
  }

  static showBottomSheetUpdate() async {}
  static showPageUpdate() async {}
}
