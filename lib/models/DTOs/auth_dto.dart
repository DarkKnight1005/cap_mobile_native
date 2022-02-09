class AuthDTO {
  AuthDTO({
    this.emailOrUsername,
    this.password,
    this.code,
    this.recaptchaToken,
    this.authToken,
    this.rememberMe = false,
  });

  String? emailOrUsername;
  String? password;
  String? code;
  String? recaptchaToken;
  String? authToken;
  bool? rememberMe = false;

  factory AuthDTO.fromMap(Map<String, dynamic> json) => AuthDTO(
        emailOrUsername: json["emailOrUsername"],
        password: json["password"],
        code: json["code"],
        recaptchaToken: json["recaptchaToken"],
        authToken: json["authToken"],
        rememberMe: json["rememberMe"],
      );

  Map<String, dynamic> toMap() => {
        "emailOrUsername": emailOrUsername,
        "password": password,
        "code": code,
        "recaptchaToken": recaptchaToken,
        "authToken": authToken,
        "rememberMe": rememberMe,
      };
}
