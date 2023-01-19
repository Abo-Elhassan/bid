import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WeatherForecastDetailsController extends GetxController {
  final WeatherForecastResponse weatherForecastDetails = Get.arguments;
  final localStorage = GetStorage();
  late String username;
  late List<Terminal> terminalList = [];
  late List<WeatherForecastResponse> weatherForecastDate = [];
  late Terminal showedTerminal = Terminal(
      portUno: 0,
      terminalUno: 0,
      terminalCode: "",
      terminalName: "",
      locationID: "",
      isSelected: false,
      isPortSelected: false);
  RxBool isloading = false.obs;

  @override
  void onInit() async {
    // username = localStorage.read('username').toString().toUpperCase();
    // try {
    //   isloading.value = true;

    //   if (await Helpers.checkConnectivity()) {
    //     final filterBody = FilterDataRequest(
    //         filterTypeUno: 4,
    //         languageUno: 1033,
    //         userUno: 9,
    //         companyUno: 1,
    //         condition: 0);

    //     final filterData =
    //         await Get.find<WidgetDataProvider>().getBIDFilterData(filterBody);
    //     final weatherBody = WeatherForecastRequest(
    //         locationID: "299429",
    //         terminalUno: 1,
    //         userUno: 9,
    //         companyUno: 1,
    //         condition: 0);
    //     weatherForecastDate.add(await Get.find<WeatherForecastProvider>()
    //         .getWeatherForecastDetails(weatherBody));

    //     terminalList = filterData.terminalList;
    //     showedTerminal = terminalList[0];

    //     isloading.value = false;

    //     if (filterData.statusCode != 200 ||
    //         weatherForecastDate[0].currentWeatherDetails.statusCode != 200) {
    //       await Helpers.dialog(
    //           Icons.error, Colors.red, 'An Error Occured While Rendering Data');
    //     }
    //   } else {
    //     await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
    //         'Please check Your Netowork Connection');
    //   }
    //   isloading.value = false;
    // } catch (error) {
    //   isloading.value = false;

    //   await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    // }
  }

  Widget buildDayWeather(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("EEEE,  MMM d")
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(
                      weatherForecastDetails
                          .dailyForecastsList![i].observationTimeEpochUTC
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
                  "assets/images/earth icon.png",
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
                                    "assets/icons/SUN.png",
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .maxTemperature !=
                                          null
                                      ? weatherForecastDetails
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
                              weatherForecastDetails
                                          .dailyForecastsList?[i].weatherText !=
                                      null
                                  ? weatherForecastDetails
                                      .dailyForecastsList![i].weatherText!
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
                                    "assets/icons/MOON.png",
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .minTemperature !=
                                          null
                                      ? weatherForecastDetails
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .windDirection !=
                                          null
                                      ? weatherForecastDetails
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .windSpeed !=
                                          null
                                      ? weatherForecastDetails
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .humidity !=
                                          null
                                      ? weatherForecastDetails
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
                                  weatherForecastDetails.dailyForecastsList?[i]
                                              .rainProbability !=
                                          null
                                      ? "${weatherForecastDetails.dailyForecastsList![i].rainProbability!} %"
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
