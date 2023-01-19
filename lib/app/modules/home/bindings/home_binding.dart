import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<WidgetDataProvider>(
      () => WidgetDataProvider(),
      fenix: true,
    );
    Get.lazyPut<WeatherForecastProvider>(
      () => WeatherForecastProvider(),
    );
  }
}
