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
    String? title, = 'New version available',
    String? content = 'Would you like to update your application?',
    String? cancelButtonText = 'Update later',
    String? updateButtonText = 'Update',
    ShowModalType? modalType = ShowModalType.alert_dialog,
    Color? backgroundColor = Colors.white,
    TextStyle? cancelTextStyle = const TextStyle(color: Colors.red),
    TextStyle? updateTextStyle = const TextStyle(color: Colors.green),
    TextStyle? titleTextStyle =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
    TextStyle? contentTextStyle,
    ButtonStyle? cancelButtonStyle,
    ButtonStyle? updateButtonStyle,
  })
  // ShowModalType.bottom_sheet (available soon )
  // ShowModalType.page (available soon )
```

## Additional information

| Next Updates                 | status      |
|------------------------------|-------------|
| Mandatory or optional update | development |
| Create TestMode              | development |
| Bottom sheet widget          | development |
| Page widget                  | development |
| Handle Exceptions            | development |
| New options custom widgets   | development |
| Automatic country detection  | development |

This project is at an initial level, more functions will be included as

So any suggestion and contribution is welcome.