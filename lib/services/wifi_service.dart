import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/material.dart';

class WifiService {
  WifiService._();

  static Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> result = await WiFiForIoTPlugin.loadWifiList();
    if (result.length >= 1){
      return result;
    }
    result.clear();
    return await WiFiForIoTPlugin.onWifiScanResultReady.first;
  }

  static Future<List<String>> loadSsidList() async {
    List<WifiNetwork> wifiNetworks = await loadWifiList();
    return List<String>.from(wifiNetworks.map((e) => e.ssid));
  }

  static Future<bool> tryToConnect({required String ssid, required String password}) async{
    debugPrint('ssid: ${ssid}, password: ${password}');
    bool? connectionStatus = await WiFiForIoTPlugin.connect(ssid, password: password, security: NetworkSecurity.WPA, joinOnce: false);
    debugPrint("Is Success To Connect --> ${connectionStatus}");
    return connectionStatus;
  }
}
