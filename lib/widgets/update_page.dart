import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ```AppVersionUpdate.showPageUpdate()``` AlertDialog widget
// ignore: must_be_immutable
class UpdateVersionPage extends StatelessWidget {
  final AppVersionResult? appVersionResult;
  final bool mandatory;
  const UpdateVersionPage({
    @required this.appVersionResult,
    this.mandatory = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !mandatory,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      'A new version is available!',
                      style:
                          TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Would you like to update your application?',
                      style:
                          TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: mandatory
                          ? const SizedBox.shrink()
                          : MaterialButton(
                              minWidth: 140.0,
                              onPressed: () => Navigator.pop(context, (route) => false),
                              color: Colors.redAccent,
                              child: const Text(
                                'Update Later',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 32.0,
                    ),
                    Flexible(
                      child: MaterialButton(
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
