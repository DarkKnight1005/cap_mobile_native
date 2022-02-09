import 'package:flutter/cupertino.dart';

class WifiNotifier extends ChangeNotifier {

  List<String> ssids = []..length = 0;
  String? _selectedSsid;

  void addSsid(String newSsid){
    ssids.add(newSsid);
  }

  void removeSstd(String _ssid){
    ssids.remove(_ssid);
  }

  set uppdaeCurrentSsid(String newVal){
    _selectedSsid = newVal;
    notifyListeners();
  }

  String? get currentSelectedSsid => _selectedSsid;

  void doNotify(){
    notifyListeners();
  }
}
