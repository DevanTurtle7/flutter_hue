import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

import 'globals/functions.dart';
import 'globals/variables.dart' as g;

import 'pages/setup/page_BridgeSelection.dart';
import 'pages/setup/page_Connecting.dart';
import 'pages/main/page_Home.dart';

SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  //debugPaintSizeEnabled = true;

  runApp(MyApp());
}

/*
Need to adjust the connect function.

- Search for bridge
- Find one and ask if you'd like to connect

yes {
  - connect
} else {
  - display all bridges found
  - connect to one

  OR

  input own ip manually
}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firefly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: prefs.getString('lastBridge') == null ? BridgeSelectionPage() : HomePage(),
    );
  }
}
