
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MultiTypeListView Demo',
      theme: new ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
