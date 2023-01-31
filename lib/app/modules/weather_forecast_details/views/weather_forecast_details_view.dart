import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weather_forecast_details_controller.dart';

class WeatherForecastDetailsView
    extends GetView<WeatherForecastDetailsController> {
  const WeatherForecastDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchData(false,
                  portName: controller.showedPort.portName);
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
                  portName: controller.showedPort.portName);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "5-DAY FORECAST",
                    style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.black,
                      fontFamily: 'Pilat Heavy',
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: controller.weatherForecastDetails.value
                            .dailyForecastsList?.length,
                        itemBuilder: (ctx, i) {
                          return controller.buildDayWeather(i);
                        }),
                  )
                ],
              ),
            ),
          );
        },
        onLoading: Center(
          child: Helpers.loadingIndicator(),
        ),
        onError: (error) => Center(
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
