import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

//test

Future<List<DiscoveryResult>> findBridges() async {
  final discovery = new BridgeDiscovery(client);

  /// search for bridges
  List<DiscoveryResult> discoverResults = await discovery.automatic();
  return discoverResults;
}

Future<Bridge> connectToBridge(DiscoveryResult discoveryResult) async {
  if (!connecting) {
    connecting = true;

    //create bridge
    Bridge bridge = new Bridge(client, discoveryResult.ipAddress);

    if (prefs.getInt('bridge' + '${discoveryResult.id}') == null) { //If there isn't a local value stored with bridge username...
      WhiteListItem whiteListItem;
      var pushLinkPushed = false;

      int count = 0;

      while (!pushLinkPushed) {
        await Future.delayed(Duration(seconds: 1)); //Wait 1 second
        try {
          whiteListItem = await bridge.createUser(
              'dart_hue#example'); //Will return error if pushLink hasnt been pressed
          print('bridge_' + '${discoveryResult.id}');
          prefs.setInt('bridge' + '${discoveryResult.id}',
              whiteListItem.username); //Save local value of bridge username
        } catch (e) {
          print('push link not pushed $count');
        }
      }

      //8muBKWrGPkp9yrLQkk-PdhkVlkBHPtCFM8zkP4mc
      //F-vufqtHK-QWWECGb0hjdNMyP3pxLAx3dsva1J2C

      // use username for consequent calls to the bridge
      bridge.username = whiteListItem.username;
      //bridge.username = 'F-vufqtHK-QWWECGb0hjdNMyP3pxLAx3dsva1J2C';
    } else {
      bridge.username = prefs.getInt('bridge' +
          '${discoveryResult.ipAddress}'); //Set bridge username to local value that was previously set
    }

    connecting = false;
    return bridge;
  }
  return null;
}

Future<void> updateLight(Bridge bridge, Light light) async {
  await bridge.updateLightState(light);
}
