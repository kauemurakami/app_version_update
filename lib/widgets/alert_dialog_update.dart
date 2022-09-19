import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ```AppVersionUpdate.showAlert()``` AlertDialog widget
// ignore: must_be_immutable
class UpdateVersionDialog extends Container {
  String? title;
  String? content;
  String? updateButtonText;
  String? cancelButtonText;
  ButtonStyle? updateButtonStyle;
  ButtonStyle? cancelButtonStyle;
  AppVersionResult? appVersionResult;
  Color? backgroundColor;
  TextStyle? titleTextStyle;
  TextStyle? contentTextStyle;
  TextStyle? cancelTextStyle;
  TextStyle? updateTextStyle;

  UpdateVersionDialog(
      {this.title,
      this.content,
      this.updateButtonText,
      this.cancelButtonText,
      this.updateButtonStyle,
      this.updateTextStyle,
      this.appVersionResult,
      this.backgroundColor,
      this.cancelButtonStyle,
      this.cancelTextStyle,
      this.contentTextStyle,
      this.titleTextStyle =
          const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        style: titleTextStyle,
      ),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: FractionallySizedBox(
        widthFactor: .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: Text(
              content!,
              maxLines: 4,
              style: contentTextStyle,
            )),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
      actions: [
        TextButton(
            style: cancelButtonStyle,
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelButtonText!,
              style: cancelTextStyle,
            )),
        TextButton(
            style: updateButtonStyle,
            onPressed: () => launchUrl(Uri.parse(appVersionResult!.storeUrl!),
                mode: LaunchMode.externalApplication),
            child: Text(
              updateButtonText!,
              style: updateTextStyle,
            ))
      ],
    );
  }
}
