import 'package:bid_app/shared/helpers.dart';
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
                controller.onInit();
              },
            ),
          ],
        ),
        body: GetX<WeatherForecastDetailsController>(
            init: WeatherForecastDetailsController(),
            builder: (controller) => (Visibility(
                  visible: controller.isloading.isFalse,
                  replacement: Helpers.loadingIndicator(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
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
                              itemCount: controller.weatherForecastDetails
                                  .dailyForecastsList?.length,
                              itemBuilder: (ctx, i) {
                                return controller.buildDayWeather(i);
                              }),
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
