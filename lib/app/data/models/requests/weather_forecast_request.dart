class WeatherForecastRequest {
  late String locationID;
  late int PortUno;
  late int userUno;
  late int companyUno;
  late int condition;

  WeatherForecastRequest({
    required this.locationID,
    required this.PortUno,
    required this.userUno,
    required this.companyUno,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      "locationID": locationID,
      "PortUno": PortUno,
      "userUno": userUno,
      "companyUno": companyUno,
      "condition": condition
    };
  }
}
