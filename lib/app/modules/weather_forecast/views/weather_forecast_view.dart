import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/shared/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:bid_app/app/modules/weather_forecast/views/weather_forecast_content.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weather_forecast_controller.dart';

class WeatherForecastView extends GetView<WeatherForecastController> {
  const WeatherForecastView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: controller.fetchData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Helpers.loadingIndicator();
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("error");
            } else {
              return WeatherForecastContent(
                controller.terminalList,
                controller.weatherForecastData,
              );
            }
          }),
    );
  }
}
