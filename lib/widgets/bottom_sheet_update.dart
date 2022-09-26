import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ```AppVersionUpdate.showBottomSheetUpdate()``` AlertDialog widget
// ignore: must_be_immutable
class BottomSheetUpdateVersion extends Container {
  final AppVersionResult? appVersionResult;
  final String? title;
  final bool? mandatory;
  final Widget? content;
  BottomSheetUpdateVersion(
      {this.appVersionResult,
      this.content,
      this.mandatory,
      this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                content ?? const SizedBox.shrink(),
                mandatory! && content == null
                    ? const Text(
                        'There is an update required, please update your app.')
                    : const Text('Would you like to update your application?'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mandatory!
                    ? const SizedBox.shrink()
                    : MaterialButton(
                        minWidth: 140.0,
                        onPressed: () =>
                            Navigator.pop(context, (route) => false),
                        color: Colors.redAccent,
                        child: const Text(
                          'Update Later',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                MaterialButton(
                  minWidth: 140.0,
                  onPressed: () async => await launchUrl(
                      Uri.parse(appVersionResult!.storeUrl!),
                      mode: LaunchMode.externalApplication),
                  color: Colors.green,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
