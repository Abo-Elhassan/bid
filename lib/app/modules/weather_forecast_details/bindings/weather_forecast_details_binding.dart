import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:get/get.dart';

import '../controllers/weather_forecast_details_controller.dart';

class WeatherForecastDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherForecastDetailsController>(
      () => WeatherForecastDetailsController(),
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
