[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/app_version_update.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/app_version_update)  

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

to use this app you need to have the app hosted in stores.

To test, you can manually downgrade your pubspec.yaml from your ```version:``` , when you run your ```local version``` it will be different from the ```store version```

## Usage

Internet permission Android:
`<uses-permission android:name="android.permission.INTERNET" />`

Internet permission iOs:
`
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
`

```dart
final appleId = '284882215'; // If this value is null, its packagename will be considered
final playStoreId = 'com.facebook.katana'; // If this value is null, its packagename will be considered

await AppVersionUpdate.checkForUpdates(
            appleId: appleId, playStoreId: playStoreId)
        .then((data) async {
            print(data.storeUrl);
            print(data.storeVersion);
            if(data.canUpdate!){
              //showDialog(... your custom widgets view) 
              //or use our widgets
              // AppVersionUpdate.showAlertUpdate
              // AppVersionUpdate.showBottomSheetUpdate
              // AppVersionUpdate.showPageUpdate
              AppVersionUpdate.showAlertUpdate(
              appVersionResult: data, context: context);
            }
         });
```

Customize the Alert Dialog

```dart
// you also have some options to customize our Alert Dialog 
AppUpdateVersion.showAlertUpdate(
    {BuildContext? context,
      AppVersionResult? appVersionResult,
      bool? mandatory = false,
      String? title = 'New version available',
      TextStyle titleTextStyle =
          const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
      String? content = 'Would you like to update your application?',
      TextStyle contentTextStyle =
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      ButtonStyle? cancelButtonStyle = const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      ButtonStyle? updateButtonStyle = const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.green)),
      String? cancelButtonText = 'UPDATE LATER',
      String? updateButtonText = 'UPDATE',
      TextStyle? cancelTextStyle = const TextStyle(color: Colors.white),
      TextStyle? updateTextStyle = const TextStyle(color: Colors.white),
      Color? backgroundColor = Colors.white})
```
Customize the our bottom sheet

```dart
AppUpdateVersion.showBottomSheetUpdate(
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
```

Customize the Page
```dart
// you also have some options to customize our Page
AppUpdateVersion.showPageUpdate(
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
  
 
```

## Additional information

| Next Updates                 | status      |
|------------------------------|-------------|
| Mandatory or optional update | released    |
| Create TestMode              | development |
| Bottom sheet widget          | released    |
| Page widget                  | released    |
| Handle Exceptions            | development |
| New options custom widgets   | released    |
| Automatic country detection  | released    |
| Modularize files             | listed      |

This project is at an initial level, more functions will be included as

So any suggestion and contribution is welcome.