class WeatherForecastRequest {
  late String locationID;
  late int terminalUno;
  late int userUno;
  late int companyUno;
  late int condition;

  WeatherForecastRequest({
    required this.locationID,
    required this.terminalUno,
    required this.userUno,
    required this.companyUno,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      "locationID": locationID,
      "terminalUno": terminalUno,
      "userUno": userUno,
      "companyUno": companyUno,
      "condition": condition
    };
  }
}
