import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    _verifyVersion();
  }

  void _verifyVersion() async {
    PackageInfo? packageInfo = await PackageInfo.fromPlatform();
    await AppVersionUpdate.checkForUpdates(
            appleId: '284882215',
            playStoreId: 'com.facebook.katana',
            country: 'br')
        .then((data) async {
      print(data);
      if (data.canUpdate!) {
        // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
        // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
        await AppVersionUpdate.showAlertUpdate(
          appVersionResult: data,
          context: context,
          backgroundColor: Colors.grey[200],
          title: 'Uma versão mais recente está disponível.',
          content:
              'Gostaria de atualizar seu aplicativo para a versão mais recente?',
          updateButtonText: 'ATUALIZAR',
          cancelButtonText: 'DEPOIS',
          titleTextStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24.0),
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        );
      }
    });
    // TODO: implement initState
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
