import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';

import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WeatherForecastDetailsController extends GetxController with StateMixin {
  final routeArguments = Get.arguments as Map<String, dynamic>;
  late Rx<WeatherForecastResponse> weatherForecastDetails =
      WeatherForecastResponse().obs;
  late Port showedPort = Port();

  @override
  void onInit() async {
    showedPort = routeArguments["showedPort"];
    weatherForecastDetails.value = routeArguments["weatherForecastDetails"];
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void fetchData(bool isInit, {String? portName}) async {
    change(null, status: RxStatus.loading());
    try {
      if (await Helpers.checkConnectivity()) {
        final weatherBody = WeatherForecastRequest(
            locationID: showedPort.locationID.toString(),
            PortUno: showedPort.portUno,
            userUno: Helpers.getCurrentUser().userUno,
            companyUno: 1,
            condition: 0);

        weatherForecastDetails.value = await Get.find<WeatherForecastProvider>()
            .getWeatherForecastDetails(weatherBody);

        if (weatherForecastDetails.value.statusCode == 401) {
          await Get.toNamed(Routes.LOGIN);
          return;
        }

        if (weatherForecastDetails.value.statusCode == 500) {
          change(null,
              status: RxStatus.error(
                  "Sorry! Intenral Server Error Occured During Rendering  Weather Forecast Data"));
          return;
        }
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      change(null, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error("Sorry! Internal Error Occured"));
    }
  }
}
