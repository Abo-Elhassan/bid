import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.fetchData(false,
                    portName: controller.showedPort.value!.portName);
              },
            ),
          ],
        ),
        drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
        body: controller.obx(
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
              "No Data Found",
              textScaleFactor: 1,
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
