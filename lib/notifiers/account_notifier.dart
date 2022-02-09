import 'dart:async';

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/services/API/account_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountNotifier extends ChangeNotifier {
  
  AuthDTO _authDTO = new AuthDTO();
  final box = GetStorage();

  late Map<String, dynamic> decodedToken;

  // Timer? _timer;

  bool? _chachedIsLogedIn;

  bool _isAuthedBio = false;

  set authDTO(AuthDTO authDTO) {
    this._authDTO = authDTO;
    if(this._authDTO.authToken != null && this._authDTO.authToken!.isNotEmpty){
        decodedToken = JwtDecoder.decode(this._authDTO.authToken!);
        box.write("auth_token", authDTO.authToken);
    }
    notifyListeners();
  }

  void doLogOut(){
    box.remove("auth_token");
    this.isBioCodeEnabled = false;
    this._authDTO = AuthDTO();
    notifyListeners();
  }

  AuthDTO get dto{
    return this._authDTO;
  }

  Future<bool> get isLogedIn async{

    checkLocalStorage();

    bool _isLogedIn = false;

    if(this._authDTO.authToken != null && this._authDTO.authToken!.isNotEmpty){
        if(JwtDecoder.isExpired(this._authDTO.authToken!)){
          _isLogedIn = false;
        }else{
          _isLogedIn = true;
        }
    }else{
      _isLogedIn = false;
    }

    if(_isLogedIn && _chachedIsLogedIn == null){
      _isLogedIn = await _getAuthUser();
    }else if(_isLogedIn && _chachedIsLogedIn != null){
      _getAuthUser();
    }

    return _isLogedIn;
  }

  Future<bool> _getAuthUser() async{

    bool _isLogedIn = this._authDTO.authToken != null ? await AccountService().getAuthUser(this._authDTO.authToken!, this) : false;

    if(_chachedIsLogedIn == null){
      _chachedIsLogedIn = _isLogedIn;
    }else{
      if(_chachedIsLogedIn != _isLogedIn){
        _chachedIsLogedIn = _isLogedIn;
        notifyListeners();
      }
    }
    return _isLogedIn;
  }

  void checkLocalStorage(){
    this._authDTO.authToken = box.read("auth_token");
  }

  set isBioCodeEnabled (bool newVal){
    box.write("isBioCodeEnabled", newVal);
  }

  bool get isBioCodeEnabled {
    return box.read("isBioCodeEnabled") ?? false;
  }

  set newBioCode (String newCode){
    box.write("BioCode", newCode);
  }

  bool checkCode(String _code){

    bool isValid;

    if(_code == box.read("BioCode")){
      isValid = true;
    }else{
      isValid = false;
    }

    return isValid;
  }

  bool get isAuthedBio {
    return _isAuthedBio;
  }

  set isAuthedBio(bool newVal){
    _isAuthedBio = newVal;
    notifyListeners();
  }


  void doNotify(){
    notifyListeners();
  }
}
