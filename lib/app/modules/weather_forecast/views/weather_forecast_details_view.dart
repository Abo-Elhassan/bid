import 'package:bid_app/app/modules/weather_forecast/views/widget_slider.dart';
import 'package:bid_app/shared/page_layout.dart';
import 'package:bid_app/shared/side_menu.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weather_forecast_details_controller.dart';

class WeatherForecastDetailsView
    extends GetView<WeatherForecastDetailsController> {
  const WeatherForecastDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      isDashboard: false,
      title: "5 DAYS FORECAST",
      onRefresh: () =>
          controller.fetchData(false, portName: controller.showedPort.portName),
      content: controller.obx(
        (state) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.fetchData(false,
                  portName: controller.showedPort.portName);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: WidgetSlider(
                controller.weatherForecastDetails.value.dailyForecastList!,
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
