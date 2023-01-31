import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WeatherForecastController extends GetxController with StateMixin {
  late Rx<FilterDataResponse> filterData = FilterDataResponse().obs;
  late RxList<Port> portList = <Port>[].obs;
  late Rx<WeatherForecastResponse> weatherForecastDetails =
      WeatherForecastResponse().obs;
  late Rx<Port?> showedPort = Port().obs;

  @override
  void onReady() {
    super.onReady();
    fetchData(true);
  }

  Future<void> getFilterData() async {
    final filterBody = FilterDataRequest(
        filterTypeUno: 3,
        languageUno: 1033,
        userUno: Helpers.getCurrentUser().userUno,
        companyUno: 1,
        condition: 0);

    filterData.value =
        await Get.find<WidgetDataProvider>().getBIDFilterData(filterBody);
    if (filterData.value.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (filterData.value.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  Future<void> getWeatherData(int portUno) async {
    final weatherBody = WeatherForecastRequest(
        locationID: showedPort.value!.locationID.toString(),
        PortUno: portUno,
        userUno: Helpers.getCurrentUser().userUno,
        companyUno: 1,
        condition: 0);

    weatherForecastDetails.value = await Get.find<WeatherForecastProvider>()
        .getWeatherForecastDetails(weatherBody);

    if (weatherForecastDetails.value.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    }
  }

  void fetchData(bool isInit, {String? portName}) async {
    change(null, status: RxStatus.loading());
    try {
      if (await Helpers.checkConnectivity()) {
        await getFilterData();
        if (filterData.value.statusCode == 500) {
          change(null,
              status: RxStatus.error(
                  "Sorry! Intenral Server Error Occured During Rendering Ports Data"));
          return;
        }

        portList.value = filterData.value.portList!;

        if (isInit) {
          showedPort.value = portList.firstWhereOrNull((port) =>
              port.portUno == Helpers.getCurrentUser().defaultPortUno);
          await getWeatherData(Helpers.getCurrentUser().defaultPortUno);
        } else {
          showedPort.value =
              portList.firstWhereOrNull((port) => port.portName == portName);
          await getWeatherData(showedPort.value!.portUno);
        }

        if (weatherForecastDetails.value.statusCode == 500) {
          change(null,
              status: RxStatus.error(
                  "Sorry! Intenral Server Error Occured During Rendering  Weather Forecast Data"));
          return;
        }

        if (showedPort.value == null) {
          change(null, status: RxStatus.empty());

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
