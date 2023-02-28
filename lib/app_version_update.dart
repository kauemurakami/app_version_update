library app_version_update;

import 'dart:io';
import 'package:app_version_update/core/functions/convert_version.dart';
import 'package:app_version_update/core/functions/fetch_version.dart';
import 'package:app_version_update/core/utils/classes.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:app_version_update/widgets/alert_dialog_update.dart';
import 'package:app_version_update/widgets/bottom_sheet_update.dart';
import 'package:app_version_update/widgets/update_page.dart';
import 'package:flutter/material.dart';

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

      AppVersionData data = await fetchVersion(
        playStoreId: playStoreId,
        appleId: appleId,
        country: country
      );

      bool canUpdate = await convertVersion(
        version: data.localVersion,
        versionStore: data.storeVersion
      );
      data.canUpdate = canUpdate;

      return AppVersionResult(
          canUpdate: data.canUpdate,
          storeUrl: data.storeUrl,
          storeVersion: data.storeVersion,
          platform: data.targetPlatform);

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
  /// * ```mandatory ``` for mandatories update default false
  /// ## example
  /// ```dart
  /// await AppVersionUpdate.showAlertUpdate(
  ///       BuildContext? context,
  ///       AppVersionResult? appVersionResult,
  ///       bool? mandatory = false,
  ///       String? title = 'New version available',
  ///       TextStyle titleTextStyle =
  ///          const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
  ///       String? content = 'Would you like to update your application?',
  ///       TextStyle contentTextStyle =
  ///           const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  ///       ButtonStyle? cancelButtonStyle = const ButtonStyle(
  ///           backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
  ///       ButtonStyle? updateButtonStyle = const ButtonStyle(
  ///           backgroundColor: MaterialStatePropertyAll(Colors.green)),
  ///       String? cancelButtonText = 'UPDATE LATER',
  ///       String? updateButtonText = 'UPDATE',
  ///       TextStyle? cancelTextStyle = const TextStyle(color: Colors.white),
  ///       TextStyle? updateTextStyle = const TextStyle(color: Colors.white),
  ///       Color? backgroundColor = Colors.white
  ///      );
  /// ```
   static showAlertUpdate(
      {BuildContext? context,
      AppVersionResult? appVersionResult,
      bool? mandatory = false,
      String? title = 'New version available',
      TextStyle? titleTextStyle = const TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.black),
      String? content = 'Would you like to update your application?',
      TextStyle? contentTextStyle = const TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black),
      ButtonStyle? cancelButtonStyle = const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      ButtonStyle? updateButtonStyle = const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.green)),
      String? cancelButtonText = 'UPDATE LATER',
      String? updateButtonText = 'UPDATE',
      TextStyle? cancelTextStyle = const TextStyle(color: Colors.white),
      TextStyle? updateTextStyle = const TextStyle(color: Colors.white),
      Color? backgroundColor = Colors.white}) async {
    await showDialog(
        barrierDismissible: !mandatory!,
        context: context!,
        builder: (context) => UpdateVersionDialog(
              appVersionResult: appVersionResult,
              backgroundColor: backgroundColor,
              cancelButtonStyle: cancelButtonStyle,
              cancelButtonText: cancelButtonText,
              cancelTextStyle: cancelTextStyle,
              content: content,
              contentTextStyle: contentTextStyle,
              title: title,
              titleTextStyle: titleTextStyle,
              mandatory: mandatory,
              updateButtonStyle: updateButtonStyle,
              updateButtonText: updateButtonText,
              updateTextStyle: updateTextStyle,
            ));
  }

  /// Used for This widget comstujma be used for updates that have terms to accept or explanations
  /// Navigate to another page, just pass your widget that will open as a page
  /// * ```appVersionResult``` result of [AppVersionUpdate.checkForUpdate()].
  /// * ```context``` build context.
  /// * ```page``` your custom page for displays update or default page in use
  /// * ```mandatory ``` for mandatories update default false
  /// ## example
  /// ```dart
  /// await AppVersionUpdate.showPageUpdate(
  ///        appVersionResult: data,
  ///        context: context,
  ///        page: MyCustomPAge()
  ///      );
  /// ```
   static showPageUpdate(
      {@required BuildContext? context,
      @required AppVersionResult? appVersionResult,
      bool? mandatory = false,
      Widget? page}) async {
    Navigator.push(
        context!,
        MaterialPageRoute(
            builder: (context) =>
                page ??
                UpdateVersionPage(
                  mandatory: mandatory,
                  appVersionResult: appVersionResult,
                )));
  }

  /// Opens a bottomsheet, with title, content and update options
  /// * ```appVersionResult``` result of [AppVersionUpdate.checkForUpdate()].
  /// * ```context``` build context.
  /// * ```page``` your custom page for displays update or default page in use
  /// * ```title``` text title
  /// * ```mandatory ``` for mandatories update default false
  /// ## example
  /// ```dart
  /// await AppVersionUpdate.showBottomSheetUpdate(
  ///        appVersionResult: data,
  ///        context: context,
  ///        content: WidgetWithContent() or use default,
  ///        title: text title bottomSheet or default
  ///      );
  /// ```
   showBottomSheetUpdate(
      {@required BuildContext? context,
      @required AppVersionResult? appVersionResult,
      bool? mandatory = false,
      String? title = 'New version avaible',
      Widget? content}) async {
    await showModalBottomSheet(
        isDismissible: !mandatory!,
        context: context!,
        builder: (context) => BottomSheetUpdateVersion(
              appVersionResult: appVersionResult,
              mandatory: mandatory,
              content: content,
              title: title,
            ));
  }

}
