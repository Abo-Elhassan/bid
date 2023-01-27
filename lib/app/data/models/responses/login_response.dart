class LoginResponse {
  late String? tokenNumber;
  late int roleType;
  late int userUno;
  late int defaultTerminalUno;
  late int defaultPortUno;
  late int statusCode;
  late String? message;
  late String? username = "";

  LoginResponse(
      {this.tokenNumber = "",
      this.roleType = 0,
      this.userUno = 0,
      this.defaultTerminalUno = 0,
      this.defaultPortUno = 0,
      this.statusCode = 0,
      this.message = "",
      this.username = ""});

  Map<String, dynamic> toJson() {
    return {
      "tokenNumber": tokenNumber,
      "roleType": roleType,
      "userUno": userUno,
      "defaultTerminalUno": defaultTerminalUno,
      "defaultPortUno": defaultPortUno,
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
    defaultPortUno = json['defaultPortUno'];
    statusCode = json['statusCode'];
    message = json['message'];
    username = json['username'];
  }
}
