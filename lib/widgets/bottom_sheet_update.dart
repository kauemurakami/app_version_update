import 'package:flutter/material.dart';

class BottomSheetUpdateVersion extends Container {
  BottomSheetUpdateVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('BottomSheetUpdateVersion')),
        body: SafeArea(
            child: Column(
          children: const [
            Text('BottomSheetUpdateVersionroller'),
          ],
        )));
  }
}
