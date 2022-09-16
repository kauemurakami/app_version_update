Retrieve version and url for local app update against store app
Android and iOS

## Features
 Using as reference packages like [in_app_update](https://pub.dev/packages/in_app_update) , [version_check](https://pub.dev/packages/version_check).

Compares local version with the respective store version for the purpose of detecting user-side version updates.

It also provides widgets like dialog , bottom sheets and pages for you to display the update option to the user.

## Getting started

```
$ flutter pub add app_version_update
```
or add in your dependencies
```
dependencies:
  app_version_update: <latest>
```

## Usage

```dart
final appleId = '1234567890'; // If this value is null, its packagename will be considered
final playStoreId = 'com.example.app'; // If this value is null, its packagename will be considered
final country = 'br' // If this value is null 'us' will be the default value
await AppVersionUpdate.checkForUpdates(
            appleId: appleId, playStoreId: playStoreId, country: country)
        .then((data) async {
            print(data.storeUrl);
            print(data.storeVersion);
            if(data.canUpdate!){
              //showDialog(... your custom widgets view) 
              //or use our widgets
              AppVersionUpdate.showAlertUpdate(
              appVersionResult: data, context: context);
            }
         });
```

Customize the Alert Dialog

```dart
// you also have some options to customize our Alert Dialog 
// ShowModalType.alert_dialog
AppUpdateVersion.showAlertUpdate({
    @required AppVersionResult? appVersionResult,
    @required BuildContext? context,
    String? title, //default 'New version available',
    String? content, //default'Would you like to update your application?',
    String? cancelButtonText, //default'Update later',
    String? updateButtonText, //default 'Update',
    ShowModalType? modalType, //default ShowModalType.alert_dialog, unique its working in momnet
    Color? backgroundColor , //default Colors.white,
    TextStyle? cancelTextStyle, //default const TextStyle(color: Colors.red),
    TextStyle? updateTextStyle , //default const TextStyle(color: Colors.green),
    TextStyle? titleTextStyle , //default
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
    TextStyle? contentTextStyle , //default null,
    ButtonStyle? cancelButtonStyle , //default null ,
    ButtonStyle? updateButtonStyle , //default null,
  })
  // ShowModalType.bottom_sheet (available soon )
  // ShowModalType.page (available soon )
```

## Additional information

This project is at an initial level, more functions will be included as

Automatic country detection, taking into account the phone's language

Responsibility to create and open Bottom Sheets and/or Alert Dialogs to display the result

Better error handling, for now you can check if any value is null.

So any suggestion and contribution is welcome.