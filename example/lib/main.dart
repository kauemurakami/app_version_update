import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_version_update_example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'app_version_update_example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
    await AppVersionUpdate.checkForUpdates(
            appleId: '284882215',
            playStoreId: 'com.facebook.katana')
        .then((result) async {
      if (result.canUpdate!) {
        // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
        // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
        // or use your own widget with information received from AppVersionResult

        //##############################################################################################
        await AppVersionUpdate.showAlertUpdate(
          appVersionResult: result,
          context: context,
          backgroundColor: Colors.grey[200],
          title: 'Uma versão mais recente está disponível.',
          titleTextStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24.0),
          content:
              'Gostaria de atualizar seu aplicativo para a versão mais recente?',
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          updateButtonText: 'ATUALIZAR',
          cancelButtonText: 'DEPOIS',
        );

        //## AppVersionUpdate.showBottomSheetUpdate ##
        // await AppVersionUpdate.showBottomSheetUpdate(
        //   context: context,
        //   mandatory: true,
        //   appVersionResult: result,
        // );

        //## AppVersionUpdate.showPageUpdate ##

        // await AppVersionUpdate.showPageUpdate(
        //   context: context,
        //   appVersionResult: result,
        // );
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
              style: Theme.of(context).textTheme.headlineMedium,
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
