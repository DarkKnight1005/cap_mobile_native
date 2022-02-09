import 'dart:developer';

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/models/responses/auth_response.dart';
import 'package:cap_mobile_native/services/API/base_service.dart';
import 'package:cap_mobile_native/services/file_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class FileDownloadService extends BaseService {
  FileDownloadService({required String getFilePath}) : super(getFilePath);
  
  FileStorage _fileStorage = FileStorage();

  Stream<String> downalodFile(AuthDTO dto) async* {

    try {
      dio.options.headers = 
      {
        "Authorization": "Bearer " + dto.authToken!
      };
      // var _options = new Options(contentType: 'application/json');
      // debugPrint("Recapthca Token(Post) --> " + dto.recaptchaToken.toString());
      // debugPrint("Post --> " + dto.toMap().toString());
      var _dioResponse = await dio.get(serviceUrl);

      // debugPrint("File Download Response --> " + _dioResponse.data);
      _fileStorage.writeFile(_dioResponse.data);
      debugPrint("Data Retrieved!");
      yield _dioResponse.data.toString();

    } catch (e) {
      var _error = e as DioError;
      debugPrint(_error.message);
    }
  }

  Future openFile() async{
    debugPrint("Openning the File!");
    await _fileStorage.openFileNative();
    // debugPrint(content);
  }

  Future deleteFile() async{
    await _fileStorage.deleteFile();
    // debugPrint(content);
  }
}
