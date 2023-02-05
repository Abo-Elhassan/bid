import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/dashboard_provider.dart';
import 'package:bid_app/app/modules/weather_forecast/controllers/weather_forecast_details_controller.dart';
import 'package:get/get.dart';

import '../controllers/weather_forecast_controller.dart';

class WeatherForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherForecastController>(
      () => WeatherForecastController(),
    );
    Get.lazyPut<WeatherForecastDetailsController>(
      () => WeatherForecastDetailsController(),
    );
    Get.lazyPut<WeatherForecastProvider>(
      () => WeatherForecastProvider(),
      fenix: true,
    );
    Get.lazyPut<DashboardProvider>(
      () => DashboardProvider(),
      fenix: true,
    );
  }
}
