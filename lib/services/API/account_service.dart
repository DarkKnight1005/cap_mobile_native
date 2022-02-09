import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/models/responses/auth_response.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/services/API/base_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AccountService extends BaseService {
  AccountService() : super('Account');

  Future<AuthResponse> auth(AuthDTO dto) async {
    late AuthResponse _response;
    try {
      
      dio.options.headers = 
      {
        "Authorization": dto.authToken ?? "", 
        "Application": "Mobile",
      };
      var _options = new Options(contentType: 'application/json', headers: {"Application": "Mobile"});

      debugPrint("Post --> " + dto.toMap().toString());
      var _dioResponse = await dio.post(
        serviceUrl + 'auth',
        options: _options,
        data: dto.toMap(),
      );
      _response = AuthResponse.fromMap(_dioResponse.data);
    } catch (e) {
      var _error = e as DioError;
      if (_error.type == DioErrorType.response) {
        debugPrint(_error.response!.data.toString());
        var _errorMessage =
            (_error.response!.data as Map<String, dynamic>)["responseException"]
                    ["exceptionMessage"]
                .toString();
        _response =
            new AuthResponse(errorMessage: _errorMessage, isError: true);
      } else {
        _response =
            new AuthResponse(errorMessage: "Network Error", isError: true);
      }
    }
    return _response;
  }

  Future<bool> getAuthUser(String token, AccountNotifier accountNotifier) async{
    bool isAuthorized = false;
    try{
      var _options = new Options(contentType: 'application/json', headers: {"Application": "Mobile", "Authorization": "Bearer " + token});
      var _dioResponse = await dio.get(
        serviceUrl + 'GetAuthorizedUser',
        options: _options,
      );

      if(_dioResponse.statusCode == 200){
        isAuthorized = true;
      }else{
        isAuthorized = false;
        accountNotifier.doLogOut();
      }
      debugPrint("Get Auth User --> " + _dioResponse.statusCode.toString());
    }catch(e){
      isAuthorized = false;
      accountNotifier.doLogOut();
      var _error = e as DioError;
      debugPrint(_error.message);
    }
    return isAuthorized;
  }
}
