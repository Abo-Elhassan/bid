class WidgetDataResponse {
  late List<BidWidgetDetails>? bidWidgetDetails;
  late int statusCode;
  late String? message;

  WidgetDataResponse({
    this.bidWidgetDetails = const <BidWidgetDetails>[],
    this.statusCode = 0,
    this.message = "",
  });

  WidgetDataResponse.fromJson(Map<String, dynamic> json) {
    bidWidgetDetails = <BidWidgetDetails>[];
    statusCode = json['statusCode'];
    message = json['message'];
    json['bidwidgetdetails'].forEach((map) {
      bidWidgetDetails?.add(BidWidgetDetails.fromJson(map));
    });
  }
}

class BidWidgetDetails {
  late String? regionCode;
  late String? countryCode;
  late String? portCode;
  late String? terminalCode;
  late String? operatorCode;
  late int regionUno;
  late int countryUno;
  late int portUno;
  late int terminalUno;
  late int operatorUno;
  late int biTypeUno;
  late String? biType;
  late int biYear;
  late String? biYearDisplay;
  late int xValue;
  late double biValue;
  late String? biUnit;
  late String? natureOfInvolvement;

  BidWidgetDetails({
    this.regionCode = "",
    this.countryCode = "",
    this.portCode = "",
    this.terminalCode = "",
    this.operatorCode = "",
    this.regionUno = 0,
    this.countryUno = 0,
    this.portUno = 0,
    this.terminalUno = 0,
    this.operatorUno = 0,
    this.biTypeUno = 0,
    this.biType = "",
    this.biYear = 0,
    this.biYearDisplay = "",
    this.xValue = 0,
    this.biValue = 0,
    this.biUnit = "",
    this.natureOfInvolvement = "",
  });

  BidWidgetDetails.fromJson(Map<String, dynamic> json) {
    regionCode = json['regionCode'];
    countryCode = json['countryCode'];
    portCode = json['portCode'];
    terminalCode = json['terminalCode'];
    operatorCode = json['operatorCode'];
    regionUno = json['regionUno'];
    countryUno = json['countryUno'];
    regionCode = json['regionCode'];
    portUno = json['portUno'];
    terminalUno = json['terminalUno'];
    operatorUno = json['operatorUno'];
    biTypeUno = json['biTypeUno'];
    biType = json['biType'];
    biYear = json['biYear'];
    biYearDisplay = json['biYearDisplay'];
    xValue = json['xValue'];
    biValue = json['biValue'];
    biUnit = json['biUnit'];
    natureOfInvolvement = json['natureOfInvolvement'];
  }
}
