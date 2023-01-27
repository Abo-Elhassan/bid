import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/bid_provider.dart';
import 'package:get/get.dart';

class WeatherForecastProvider extends BidProvider {
  Future<WeatherForecastResponse> getWeatherForecastDetails(
      WeatherForecastRequest request) async {
    try {
      // var responseBody = {
      //   "currentWeatherDetails": {
      //     "observationTimeEpochUTC": "1674020400",
      //     "weatherText": "Mostly cloudy",
      //     "temperature": "19.5°C",
      //     "windDirection": "S",
      //     "windSpeed": "29.7 km/h",
      //     "weatherIcon": 6,
      //     "humidity": "70%",
      //     "statusCode": 200,
      //     "message": "Success"
      //   },
      //   "dailyForecastsList": [
      //     {
      //       "observationTimeEpochUTC": "1673987400",
      //       "weatherText": "Showers",
      //       "minTemperature": "2.8°C",
      //       "maxTemperature": "24.4°C",
      //       "humidity": null,
      //       "rainProbability": "90",
      //       "windDirection": "S",
      //       "windSpeed": "22.2 km/h",
      //       "weatherIcon": 12,
      //       "statusCode": 200,
      //       "message": "Success"
      //     },
      //     {
      //       "observationTimeEpochUTC": "1674073800",
      //       "weatherText": "Sunny",
      //       "minTemperature": "6.3°C",
      //       "maxTemperature": "22.4°C",
      //       "humidity": null,
      //       "rainProbability": "0",
      //       "windDirection": "SSE",
      //       "windSpeed": "29.6 km/h",
      //       "weatherIcon": 1,
      //       "statusCode": 200,
      //       "message": "Success"
      //     },
      //     {
      //       "observationTimeEpochUTC": "1674160200",
      //       "weatherText": "Intermittent clouds",
      //       "minTemperature": "9.2°C",
      //       "maxTemperature": "25.3°C",
      //       "humidity": null,
      //       "rainProbability": "0",
      //       "windDirection": "SSE",
      //       "windSpeed": "24.1 km/h",
      //       "weatherIcon": 4,
      //       "statusCode": 200,
      //       "message": "Success"
      //     },
      //     {
      //       "observationTimeEpochUTC": "1674246600",
      //       "weatherText": "Sunny",
      //       "minTemperature": "12.8°C",
      //       "maxTemperature": "29.5°C",
      //       "humidity": null,
      //       "rainProbability": "0",
      //       "windDirection": "S",
      //       "windSpeed": "24.1 km/h",
      //       "weatherIcon": 1,
      //       "statusCode": 200,
      //       "message": "Success"
      //     },
      //     {
      //       "observationTimeEpochUTC": "1674333000",
      //       "weatherText": "Sunny",
      //       "minTemperature": "17.3°C",
      //       "maxTemperature": "32.1°C",
      //       "humidity": null,
      //       "rainProbability": "0",
      //       "windDirection": "SE",
      //       "windSpeed": "18.5 km/h",
      //       "weatherIcon": 1,
      //       "statusCode": 200,
      //       "message": "Success"
      //     }
      //   ],
      //   "statusCode": 200,
      //   "message": "Success"
      // };
      var body = request.toJson();
      final response =
          await post('/WeatherForecast/GetWeatherForecastDetails', body);

      late WeatherForecastResponse weatherForecastResponse =
          WeatherForecastResponse();
      if (response.statusCode == 401) {
        weatherForecastResponse.statusCode = 401;
        return weatherForecastResponse;
      } else if (response.statusCode == 500) {
        weatherForecastResponse.statusCode = 500;
        return weatherForecastResponse;
      }
      if (response.body != null) {
        weatherForecastResponse =
            WeatherForecastResponse.fromJson(response.body);
      }

      return weatherForecastResponse;
    } catch (e) {
      rethrow;
    }
  }
}
