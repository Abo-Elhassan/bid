import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

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

  Widget buildDayWeather(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("EEEE,  MMM d")
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(
                      weatherForecastDetails
                          .value.dailyForecastsList![i].observationTimeEpochUTC
                          .toString()) *
                  1000))
              .toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat Light',
            fontSize: 16,
          ),
        ),
        Container(
          height: 120,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Stack(children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  Assets.kEarthLines,
                  height: MediaQuery.of(Get.context!).size.height * 0.12,
                  opacity: const AlwaysStoppedAnimation(.3),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    Assets.kMaxTemperature,
                                    height: MediaQuery.of(Get.context!)
                                            .size
                                            .height *
                                        0.03,
                                    opacity: const AlwaysStoppedAnimation(.3),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .maxTemperature !=
                                          null
                                      ? weatherForecastDetails
                                          .value
                                          .dailyForecastsList![i]
                                          .maxTemperature!
                                      : "N/A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              weatherForecastDetails.value
                                          .dailyForecastsList?[i].weatherText !=
                                      null
                                  ? weatherForecastDetails
                                      .value.dailyForecastsList![i].weatherText!
                                  : "N/A",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat ',
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    Assets.kMinTemperature,
                                    height: MediaQuery.of(Get.context!)
                                            .size
                                            .height *
                                        0.025,
                                    opacity: const AlwaysStoppedAnimation(.3),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .minTemperature !=
                                          null
                                      ? weatherForecastDetails
                                          .value
                                          .dailyForecastsList![i]
                                          .minTemperature!
                                      : "N/A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Wind Direction",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(110, 110, 114, 1),
                                    fontFamily: 'Pilat Light',
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .windDirection !=
                                          null
                                      ? weatherForecastDetails.value
                                          .dailyForecastsList![i].windDirection!
                                          .toUpperCase()
                                      : "N/A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Wind Speed",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(110, 110, 114, 1),
                                    fontFamily: 'Pilat Light',
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .windSpeed !=
                                          null
                                      ? weatherForecastDetails.value
                                          .dailyForecastsList![i].windSpeed!
                                          .toUpperCase()
                                      : "N/A",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(110, 110, 114, 1),
                                    fontFamily: 'Pilat Light',
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .humidity !=
                                          null
                                      ? weatherForecastDetails.value
                                          .dailyForecastsList![i].humidity!
                                          .toUpperCase()
                                      : "N/A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Rain Probability",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(110, 110, 114, 1),
                                    fontFamily: 'Pilat Light',
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherForecastDetails
                                              .value
                                              .dailyForecastsList?[i]
                                              .rainProbability !=
                                          null
                                      ? "${weatherForecastDetails.value.dailyForecastsList![i].rainProbability!} %"
                                      : "N/A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat ',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
