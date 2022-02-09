import 'package:cap_mobile_native/models/responses/base_response.dart';

class AuthResponse extends BaseResponse {
  AuthResponse({
    this.version,
    this.statusCode,
    this.message,
    this.isError,
    this.errorMessage,
    this.result,
  }) : super(errorMesage: errorMessage, isSucceded: !isError!);

  final dynamic version;
  final int? statusCode;
  final String? message;
  final bool? isError;
  final String? errorMessage;
  final Result? result;

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        version: json["version"],
        statusCode: json["statusCode"],
        message: json["message"],
        isError: json["isError"],
        result: json["result"] == null ? null : Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "version": version,
        "statusCode": statusCode,
        "message": message,
        "isError": isError,
        "result": result == null ? null : result!.toMap(),
      };
}

class Result {
  Result({
    this.isSigned,
    this.token,
    this.requiredConfirm,
    this.message,
  });

  bool? isSigned;
  dynamic token;
  bool? requiredConfirm;
  String? message;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        isSigned: json["isSigned"],
        token: json["token"],
        requiredConfirm: json["requiredConfirm"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "isSigned": isSigned,
        "token": token,
        "requiredConfirm": requiredConfirm,
        "message": message,
      };
}
