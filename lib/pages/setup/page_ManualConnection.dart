import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';
import '../../globals/functions.dart';
import '../../globals/variables.dart' as g;

import 'page_Connecting.dart';
import '../main/page_Home.dart';

class ManualConnection extends StatefulWidget {
  const ManualConnection({Key key}) : super(key: key);

  @override
  ManualConnectionState createState() => ManualConnectionState();
}

class ManualConnectionState extends State<ManualConnection> {
  final ipController = TextEditingController();
  bool ipError = false;

  void manualConnect() async {
    final discovery = BridgeDiscovery(g.client);
    try {
      print('connecting...');
      DiscoveryResult discoveryResult =
          await discovery.manual(ipController.text);
      Navigator.push(
          context,
          SlideLeftRoute(
              page: ConnectingPage(
            bridge: discoveryResult,
          )));
    } catch (e) {
      setState(() {
        ipError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ipController.addListener(() {
      setState(() {
        ipError = false;
      });
    });

    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text("Enter the Bridge's IP Address",
                  style: new TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w400))),
          Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 300,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 250,
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          controller: ipController,
                          maxLength: 15,
                          textAlign: TextAlign.center,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter(RegExp(r'[0-9.]*'))
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "IP Address",
                              errorText: ipError ? "Invalid IP Address" : null),
                        ),
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        elevation: 5,
                        disabledTextColor: Colors.black26,
                        disabledColor: Colors.black12,
                        disabledElevation: 0,
                        onPressed: manualConnect,
                        child: const Text('Connect',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  )))
        ])));
  }
}
