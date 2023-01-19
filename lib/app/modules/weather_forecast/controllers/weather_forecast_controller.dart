import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WeatherForecastController extends GetxController {
  final localStorage = GetStorage();

  late List<Terminal> terminalList = <Terminal>[];
  late WeatherForecastResponse weatherForecastData = WeatherForecastResponse();
  late Terminal? showedTerminal = terminalList[0];
  RxBool isloading = false.obs;

  Future<void> fetchData() async {
    try {
      if (await Helpers.checkConnectivity()) {
        final filterBody = FilterDataRequest(
            filterTypeUno: 4,
            languageUno: 1033,
            userUno: Helpers.getCurrentUser().userUno,
            companyUno: 1,
            condition: 0);

        final filterData =
            await Get.find<WidgetDataProvider>().getBIDFilterData(filterBody);
        if (filterData.statusCode != 200 || filterData.terminalList == null) {
          await Helpers.dialog(Icons.error, Colors.red,
              'An Error Occured While Rendering Terminal Data');
          return;
        }

        terminalList = filterData.terminalList!;

        showedTerminal = terminalList.firstWhereOrNull((terminal) =>
            terminal.terminalUno ==
            Helpers.getCurrentUser().defaultTerminalUno);

        if (showedTerminal == null) {
          await Helpers.dialog(
              Icons.error, Colors.red, 'Default Terminal Data Not Found');
          return;
        }

        final weatherBody = WeatherForecastRequest(
            locationID: showedTerminal!.locationID.toString(),
            terminalUno: Helpers.getCurrentUser().defaultTerminalUno,
            userUno: Helpers.getCurrentUser().userUno,
            companyUno: 1,
            condition: 0);

        weatherForecastData = await Get.find<WeatherForecastProvider>()
            .getWeatherForecastDetails(weatherBody);

        // if (weatherForecastData.statusCode != 200) {
        //   await Helpers.dialog(
        //       Icons.error, Colors.red, 'An Error Occured While Rendering Data');
        //   return;
        // }
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      isloading.value = false;
    } catch (error) {
      isloading.value = false;

      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }
}
