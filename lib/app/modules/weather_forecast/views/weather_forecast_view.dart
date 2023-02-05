import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/shared/page_layout.dart';
import 'package:bid_app/shared/side_menu.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/modules/weather_forecast/views/weather_forecast_content.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weather_forecast_controller.dart';

class WeatherForecastView extends GetView<WeatherForecastController> {
  const WeatherForecastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isDashboard: false,
        onRefresh: () => controller.fetchData(false,
            portName: controller.showedPort.value!.portName),
        content: controller.obx(
          (state) {
            return RefreshIndicator(
                onRefresh: () async {
                  controller.fetchData(false,
                      portName: controller.showedPort.value?.portName);
                },
                child: WeatherForecastContent(
                    weatherForecastDetails:
                        controller.weatherForecastDetails.value,
                    portList: controller.portList,
                    showedPort: controller.showedPort.value!,
                    updateData: controller.fetchData));
          },
          onLoading: Center(
            child: Helpers.loadingIndicator(),
          ),
          onEmpty: Center(
            child: Text(
              "Default Port Not Found",
              style: TextStyle(fontFamily: "Pilat Heavy", fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          onError: (error) => Center(
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Pilat Heavy", fontSize: 22),
            ),
          ),
        ));
  }
}
