class WeatherForecastResponse {
  late List<DailyForecast>? dailyForecastList;
  late CurrentWeatherDetails? currentWeatherDetails;
  late int statusCode;
  late String? message;

  WeatherForecastResponse({
    this.dailyForecastList = const <DailyForecast>[],
    this.currentWeatherDetails,
    this.statusCode = 0,
    this.message = "",
  });

  WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    dailyForecastList = <DailyForecast>[];
    currentWeatherDetails =
        CurrentWeatherDetails.fromJson(json['currentWeatherDetails']);

    json['dailyForecastsList'].forEach((map) {
      dailyForecastList?.add(DailyForecast.fromJson(map));
    });
    statusCode = json['statusCode'];
    message = json['message'];
  }
}

class CurrentWeatherDetails {
  late String? observationTimeEpochUTC;
  late String? weatherText;
  late String? temperature;
  late String? windDirection;
  late String? windSpeed;
  late int weatherIcon;
  late String? humidity;
  late int statusCode;
  late String? message;

  CurrentWeatherDetails({
    this.observationTimeEpochUTC = "",
    this.weatherText = "",
    this.temperature = "",
    this.windDirection = "",
    this.windSpeed = "",
    this.weatherIcon = 0,
    this.humidity = "",
    this.statusCode = 0,
    this.message = "",
  });

  CurrentWeatherDetails.fromJson(Map<String, dynamic> json) {
    observationTimeEpochUTC = json['observationTimeEpochUTC'];
    weatherText = json['weatherText'];
    temperature = json['temperature'];
    windDirection = json['windDirection'];
    windSpeed = json['windSpeed'];
    weatherIcon = json['weatherIcon'];
    humidity = json['humidity'];
    statusCode = json['statusCode'];
    message = json['message'];
  }
}

class DailyForecast {
  late String? observationTimeEpochUTC;
  late String? weatherText;
  late String? minTemperature;
  late String? maxTemperature;
  late String? humidity;
  late String? rainProbability;
  late String? windDirection;
  late String? windSpeed;
  late int weatherIcon;
  late int statusCode;
  late String? message;

  DailyForecast({
    this.observationTimeEpochUTC = "",
    this.weatherText = "",
    this.minTemperature = "",
    this.maxTemperature = "",
    this.humidity = "",
    this.rainProbability = "",
    this.windDirection = "",
    this.windSpeed = "",
    this.weatherIcon = 0,
    this.statusCode = 0,
    this.message = "",
  });

  DailyForecast.fromJson(Map<String, dynamic> json) {
    observationTimeEpochUTC = json['observationTimeEpochUTC'];
    weatherText = json['weatherText'];
    minTemperature = json['minTemperature'];
    maxTemperature = json['maxTemperature'];
    humidity = json['humidity'];
    rainProbability = json['rainProbability'];
    windDirection = json['windDirection'];
    windSpeed = json['windSpeed'];
    weatherIcon = json['weatherIcon'];
    statusCode = json['statusCode'];
    message = json['message'];
  }
}
