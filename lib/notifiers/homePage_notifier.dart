import 'dart:async';

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePageNotifier extends ChangeNotifier {
  
  bool _isWebViewLoaded = true;
  bool _isPDFOpen = false;

  bool get loadedStatus{
    return _isWebViewLoaded;
  }

  set loadedStatus(bool newVal){
    _isWebViewLoaded = newVal;
    notifyListeners();
  }

  bool get pdfStatus{
    return _isPDFOpen;
  }

  set pdfStatus(bool newVal){
    _isPDFOpen = newVal;
    notifyListeners();
  }

  void doNotify(){
    notifyListeners();
  }
}
