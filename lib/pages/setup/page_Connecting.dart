import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';
import '../../globals/functions.dart';
import '../../globals/variables.dart' as g;

import 'page_BridgeSelection.dart';
import '../main/page_Home.dart';

class ConnectingPage extends StatefulWidget {
  final DiscoveryResult bridge;

  const ConnectingPage({Key key, this.bridge}) : super(key: key);

  @override
  ConnectingPageState createState() => ConnectingPageState();
}

class ConnectingPageState extends State<ConnectingPage> {
  @override
  Widget build(BuildContext context) {
    final DiscoveryResult bridge = widget.bridge;
    connectToBridge(bridge);

    Future<bool> onPop() async {
      g.connecting = false;
      Navigator.of(context).pop(true);
      return false;
    }

    return WillPopScope(
      onWillPop: onPop ,
      child:Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(children: <Widget>[
        Text('Connecting to Bridge',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
        Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 10),
            child: Text('Press the pushlink button on your bridge to continue',
                textAlign: TextAlign.center,
                style:
                    new TextStyle(fontSize: 20, fontWeight: FontWeight.w400))),]),
        SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.width * .5,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text('Help', style: TextStyle(fontSize: 18, color: Colors.blue)),
        )
      ],
    ))));
  }
}