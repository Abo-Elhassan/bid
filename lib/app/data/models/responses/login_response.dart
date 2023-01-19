class LoginResponse {
  late String? tokenNumber;
  late int roleType;
  late int userUno;
  late int defaultTerminalUno;
  late int statusCode;
  late String? message;
  late String? username = "";

  LoginResponse(
      {this.tokenNumber = "",
      this.roleType = 0,
      this.userUno = 0,
      this.defaultTerminalUno = 0,
      this.statusCode = 0,
      this.message = "",
      this.username = ""});

  Map<String, dynamic> toJson() {
    return {
      "tokenNumber": tokenNumber,
      "roleType": roleType,
      "userUno": userUno,
      "defaultTerminalUno": defaultTerminalUno,
      "statusCode": statusCode,
      "message": message,
      "username": username,
    };
  }

  LoginResponse.fromJson(Map<String, dynamic> json) {
    tokenNumber = json['tokenNumber'];
    roleType = json['roleType'];
    userUno = json['userUno'];
    defaultTerminalUno = json['defaultTerminalUno'];
    statusCode = json['statusCode'];
    message = json['message'];
    username = json['username'];
  }
}
