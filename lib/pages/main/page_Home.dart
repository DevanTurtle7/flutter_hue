import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';
import '../../globals/functions.dart';

import '../setup/page_BridgeSelection.dart';
import '../setup/page_Connecting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class TabButton extends StatefulWidget {
  final String name;

  const TabButton({this.name});

  @override
  State<StatefulWidget> createState() => TabButtonState(name: this.name);
}

class TabButtonState extends State<TabButton> {
  TabButtonState({this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final String name = widget.name;

    return GestureDetector(
        onTap: () {
          print('Hello');
        },
        child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 15,
              right: 15,
            ),
            child: Text(name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ))));
  }
}

class Tab {
  String name;

  Tab(String name) {
    this.name = name;
  }
}

class HomePageState extends State<HomePage> {
  var tabs = [Tab('Page 1'), Tab('Page 2')];
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              itemCount: tabs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int i) {
                                return TabButton(
                                  name: tabs[i].name,
                                );
                              }),
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, top: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    )
                    /*Row(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              print('Hello');
                            },
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Page1',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ))),
                        RawMaterialButton(
                          child: Text('Page2'),
                          onPressed: () {},
                        ),
                      ],
                    )),*/
                    ),
                Expanded(
                    flex: 10,
                    child: PageView(
                      children: <Widget>[
                        Center(
                          child: Text('hi'),
                        ),
                        Center(
                          child: Text('hi'),
                        )
                      ],
                      pageSnapping: true,
                    ))
              ],
            )));
  }
}
