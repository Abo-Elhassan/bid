import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:get/get.dart';

import '../controllers/weather_forecast_controller.dart';

class WeatherForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherForecastController>(
      () => WeatherForecastController(),
    );
    Get.lazyPut<WeatherForecastProvider>(
      () => WeatherForecastProvider(),
      fenix: true,
    );
    Get.lazyPut<WidgetDataProvider>(
      () => WidgetDataProvider(),
      fenix: true,
    );
  }
}
