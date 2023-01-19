class WidgetDataRequest {
  late String regionUno;
  late String countryUno;
  late String portUno;
  late String terminalUno;
  late String operatorUno;
  late String widgetTypeUno;
  late int companyUno;
  late int userUno;
  late int condition;

  WidgetDataRequest({
    required this.regionUno,
    required this.countryUno,
    required this.portUno,
    required this.terminalUno,
    required this.operatorUno,
    required this.widgetTypeUno,
    required this.companyUno,
    required this.userUno,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      "regionUno": regionUno,
      "countryUno": countryUno,
      "portUno": portUno,
      "terminalUno": terminalUno,
      "operatorUno": operatorUno,
      "widgetTypeUno": widgetTypeUno,
      "companyUno": companyUno,
      "userUno": userUno,
      "condition": condition
    };
  }
}
