import 'package:bid_app/shared/charts/geo_json.dart';
import 'package:get/get.dart';

class FilterDataResponse {
  late List<Region>? regionList;
  late List<Country>? countryList;
  late List<Port>? portList;
  late List<Terminal>? terminalList;
  late List<Operator>? operatorList;
  late int statusCode;
  late String? message;

  FilterDataResponse({
    this.regionList = const <Region>[],
    this.countryList = const <Country>[],
    this.portList = const <Port>[],
    this.terminalList = const <Terminal>[],
    this.operatorList = const <Operator>[],
    this.statusCode = 0,
    this.message = "",
  });

  FilterDataResponse.fromJson(Map<String, dynamic> json) {
    regionList = <Region>[];
    countryList = <Country>[];
    portList = <Port>[];
    terminalList = <Terminal>[];
    operatorList = <Operator>[];
    statusCode = json['statusCode'];
    message = json['message'];
    json['regionList'].forEach((map) {
      regionList?.add(Region.fromJson(map));
    });

    json['countryList'].forEach((map) {
      countryList?.add(Country.fromJson(map));
    });

    json['portList'].forEach((map) {
      portList?.add(Port.fromJson(map));
    });

    json['terminalList'].forEach((map) {
      terminalList?.add(Terminal.fromJson(map));
    });

    json['operatorList'].forEach((map) {
      operatorList?.add(Operator.fromJson(map));
    });
  }
}

class Region {
  late int regionUno;
  late String? regionCode;
  late String? regionName;
  late bool isSelected;
  late bool isFitlerSelected;
  Region({
    this.regionUno = 0,
    this.regionCode = "",
    this.regionName = "",
    this.isSelected = true,
    this.isFitlerSelected = false,
  });

  Region.fromJson(Map<String, dynamic> json) {
    regionUno = json['regionUno'];
    regionCode = json['regionCode'];
    regionName = json['regionName'];
    isSelected = true;
    isFitlerSelected = false;
  }
}

class Country {
  late int countryUno;
  late int regionUno;
  late String? countryCode;
  late String? countryName;
  late num latitude;
  late num longitude;
  late String? centrePoint;
  late List<List<double>>? coordinates;
  late bool isSelected;
  late bool isFitlerSelected;
  late bool isRegionSelected;
  Country({
    this.countryUno = 0,
    this.regionUno = 0,
    this.countryCode = "",
    this.countryName = "",
    this.latitude = 0,
    this.longitude = 0,
    this.centrePoint = "",
    this.coordinates = const [],
    this.isSelected = true,
    this.isFitlerSelected = false,
    this.isRegionSelected = true,
  });

  Country.fromJson(Map<String, dynamic> json) {
    countryUno = json['countryUno'];
    regionUno = json['regionUno'];
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    centrePoint = json['centrePoint'];
    coordinates = GeoJson.countires
        .firstWhereOrNull((con) => con.countryUno == countryUno)
        ?.coordinates;
    isSelected = true;
    isFitlerSelected = false;
    isRegionSelected = true;
  }
}

class Port {
  late int countryUno;
  late int portUno;
  late String? portCode;
  late String? portName;
  late String? locationID;
  late num latitude;
  late num longitude;
  late String? centrePoint;
  late bool isSelected;
  late bool isFitlerSelected;
  late bool isCountrySelected;
  Port(
      {this.countryUno = 0,
      this.portUno = 0,
      this.portCode = "",
      this.portName = "",
      this.locationID = "",
      this.latitude = 0,
      this.longitude = 0,
      this.centrePoint = "",
      this.isSelected = true,
      this.isFitlerSelected = false,
      this.isCountrySelected = true});

  Port.fromJson(Map<String, dynamic> json) {
    countryUno = json['countryUno'];
    portUno = json['portUno'];
    portCode = json['portCode'];
    portName = json['portName'];
    locationID = json['locationID'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    centrePoint = json['centrePoint'];
    isSelected = true;
    isFitlerSelected = false;
    isCountrySelected = true;
  }
}

class Terminal {
  late int portUno;
  late int terminalUno;
  late String? terminalCode;
  late String? terminalName;
  late String? locationID;
  late bool isSelected;
  late bool isFitlerSelected;
  late bool isPortSelected;
  Terminal({
    this.portUno = 0,
    this.terminalUno = 0,
    this.terminalCode = "",
    this.terminalName = "",
    this.locationID = "",
    this.isSelected = true,
    this.isFitlerSelected = false,
    this.isPortSelected = true,
  });

  Terminal.fromJson(Map<String, dynamic> json) {
    portUno = json['portUno'];
    terminalUno = json['terminalUno'];
    terminalCode = json['terminalCode'];
    terminalName = json['terminalName'];
    locationID = json['locationID'];

    isSelected = true;
    isFitlerSelected = false;
    isPortSelected = true;
  }
}

class Operator {
  late int portUno;
  late int operatorUno;
  late String? operatorCode;
  late String? operatorName;
  late bool isSelected;
  late bool isFitlerSelected;
  late bool isPortSelected;
  Operator({
    this.portUno = 0,
    this.operatorUno = 0,
    this.operatorCode = "",
    this.operatorName = "",
    this.isSelected = true,
    this.isFitlerSelected = false,
    this.isPortSelected = true,
  });

  Operator.fromJson(Map<String, dynamic> json) {
    portUno = json['portUno'];
    operatorUno = json['operatorUno'];
    operatorCode = json['operatorCode'];
    operatorName = json['operatorName'];
    isSelected = true;
    isFitlerSelected = false;
    isPortSelected = true;
  }
}
