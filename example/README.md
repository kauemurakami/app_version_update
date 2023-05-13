# app_version_update_example

A new Flutter project.

## Getting started to test

```
$ flutter pub add app_version_update
```
or add in your dependencies
```
dependencies:
  app_version_update: <latest>
```

to use this app you need to have the app hosted in stores. (we have one as a reference, whenever it is < 4.14.0, there is an update)

To test, you can manually downgrade your pubspec.yaml from your ```version: 10.0.0``` , when you run your ```local version``` it will be different from the ```store version```

so to make sure you can test it we leave commented versions in the pubspec yaml of the example.
```version: 10.0.0``` no have update
```version: 1.0.0``` have update
