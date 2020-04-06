import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';
import '../../globals/functions.dart';

import 'page_Connecting.dart';
import '../main/page_Home.dart';

class BridgeSelectionPage extends StatefulWidget {
  BridgeSelectionPage({Key key}) : super(key: key);

  @override
  BridgeSelectionPageState createState() => BridgeSelectionPageState();
}

class BridgeSelectionPageState extends State<BridgeSelectionPage> {
  double sliderVal = 20;
  int selectedIndex;
  DiscoveryResult chosenBridge;

  void sliderChange(e) {
    setState(() {
      sliderVal = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('Select a Bridge',
                style:
                    new TextStyle(fontSize: 25, fontWeight: FontWeight.w400))),
        Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.65,
            child: new Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: FutureBuilder(
                  future: findBridges(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //print('theres data');
                      return new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new ListTile(
                              title: Text('Bridge ${snapshot.data[index].id}',
                                  style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.blue
                                          : Colors.black87)),
                              subtitle: Text(
                                  'IP: ${snapshot.data[index].ipAddress}',
                                  style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.blue
                                          : Colors.black54)),
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.highlight,
                                        size: 30,
                                        color: selectedIndex == index
                                            ? Colors.blue
                                            : Colors.black45)
                                  ]),
                              trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.info_outline, size: 30),
                                      onPressed: () {},
                                    )
                                  ]),
                              onTap: () {
                                setState(() {
                                  selectedIndex = selectedIndex == index ? null : index;
                                  chosenBridge = snapshot.data[index];
                                });
                                print(snapshot.data[index]);
                                //connectToBridge(snapshot.data[index]);
                              },
                            );
                          });
                    } else {
                      return new Center(child: CircularProgressIndicator());
                    }
                  }),
            )),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  textColor: Colors.blue,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {},
                  child: Text(
                    "Manual",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  elevation: 5,
                  disabledTextColor: Colors.black26,
                  disabledColor: Colors.black12,
                  disabledElevation: 0,
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              SlideLeftRoute(
                                  page: ConnectingPage(
                                bridge: chosenBridge,
                              )));
                        },
                  child: const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ],
            ))
      ])),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connectToBridge(null);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/
    );
  }
}