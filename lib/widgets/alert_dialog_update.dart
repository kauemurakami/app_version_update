import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  UpdateVersionDialog(
      {this.title,
      this.content,
      this.updateButtonText,
      this.cancelButtonText,
      this.updateButtonStyle,
      this.appVersionResult,
      this.backgroundColor,
      this.cancelButtonStyle,
      this.contentTextStyle,
      this.titleTextStyle,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content: Text(content!),
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
      actions: [
        TextButton(
            style: cancelButtonStyle,
            onPressed: () => Navigator.pop(context),
            child: Text(cancelButtonText!)),
        TextButton(
            style: updateButtonStyle,
            onPressed: () => launchUrl(Uri.parse(appVersionResult!.storeUrl!),
                mode: LaunchMode.externalApplication),
            child: Text(updateButtonText!))
      ],
    );
  }
}
