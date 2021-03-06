import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

//test of other computer

import '../main.dart';
import 'variables.dart' as g;

import '../pages/setup/page_BridgeSelection.dart';
import '../pages/setup/page_Connecting.dart';
import '../pages/main/page_Home.dart';

Future<List<DiscoveryResult>> findBridges() async {
  final discovery = new BridgeDiscovery(g.client);

  /// search for bridges
  List<DiscoveryResult> discoverResults = await discovery.automatic();
  return discoverResults;
}

Future<Bridge> connectToBridge(DiscoveryResult discoveryResult) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('connect called');
  if (!g.connecting) {
    g.connecting = true;

    //create bridge
    Bridge bridge = new Bridge(g.client, discoveryResult.ipAddress);

    if (prefs.getString('bridge' + '${discoveryResult.id}') == null) {
      //If there isn't a local value stored with bridge username...
      WhiteListItem whiteListItem;
      var pushLinkPushed = false;

      int count = 0;

      while (!pushLinkPushed && g.connecting) {
        await Future.delayed(Duration(seconds: 1)); //Wait 1 second
        try {
          whiteListItem = await bridge.createUser(
              'dart_hue#example'); //Will return error if pushLink hasnt been pressed
          print('bridge_' + '${discoveryResult.id}');
          prefs.setString('bridge' + '${discoveryResult.id}',
              whiteListItem.username.toString()); //Save local value of bridge username
          
          pushLinkPushed = true;
          print('hellooooo');
          print(pushLinkPushed);
        } catch (e) {
          print(count);
          //print('push link not pushed $count');
          //print(g.connecting);
        }

        count++;
      }

      //8muBKWrGPkp9yrLQkk-PdhkVlkBHPtCFM8zkP4mc
      //F-vufqtHK-QWWECGb0hjdNMyP3pxLAx3dsva1J2C

      // use username for consequent calls to the bridge
      if (g.connecting) {
        bridge.username = whiteListItem.username;
      }
      //bridge.username = 'F-vufqtHK-QWWECGb0hjdNMyP3pxLAx3dsva1J2C';
    } else {
      print('bridge was already saved');
      bridge.username = prefs.getString('bridge' +
          '${discoveryResult.ipAddress}'); //Set bridge username to local value that was previously set
    }

    if (g.connecting) {
      prefs.setString('lastBridge', discoveryResult.ipAddress.toString());

      g.connecting = false;
      return bridge;
    } else {
      return null;
    }
  }
  return null;
}

Future<void> updateLight(Bridge bridge, Light light) async {
  await bridge.updateLightState(light);
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCirc)).animate(animation),
            child: child,
          ),
        );
}
