import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/dropdown_list.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WeatherForecastContent extends StatelessWidget {
  final WeatherForecastResponse weatherForecastDetails;
  final List<Port> portList;
  final Port showedPort;
  final Function updateData;

  const WeatherForecastContent(
      {required this.weatherForecastDetails,
      required this.portList,
      required this.showedPort,
      required this.updateData});

  List<Widget> buildContent() {
    return [
      ListTile(
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastsList![1].weatherIcon),
          height: MediaQuery.of(Get.context!).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "Tomorrow - ${weatherForecastDetails.dailyForecastsList![1].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastsList![1].minTemperature} / ${weatherForecastDetails.dailyForecastsList![1].maxTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastsList![2].weatherIcon),
          height: MediaQuery.of(Get.context!).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(weatherForecastDetails.dailyForecastsList![2].observationTimeEpochUTC.toString()) * 1000))} - ${weatherForecastDetails.dailyForecastsList![2].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastsList![2].minTemperature} / ${weatherForecastDetails.dailyForecastsList![2].maxTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastsList![3].weatherIcon),
          height: MediaQuery.of(Get.context!).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(weatherForecastDetails.dailyForecastsList![3].observationTimeEpochUTC.toString()) * 1000))} - ${weatherForecastDetails.dailyForecastsList![3].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastsList![3].minTemperature} / ${weatherForecastDetails.dailyForecastsList![3].maxTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return weatherForecastDetails.statusCode == 200
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropDownList(
                    portList: portList,
                    showedPort: showedPort,
                    updateData: updateData),
                SizedBox(
                  height: 20,
                ),
                Text(
                  weatherForecastDetails.currentWeatherDetails?.temperature !=
                          null
                      ? '${weatherForecastDetails.currentWeatherDetails!.temperature!} '
                      : "N/A".toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat Heavy',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  Assets.weatherIcon(weatherForecastDetails
                      .currentWeatherDetails!.weatherIcon),
                  height: MediaQuery.of(context).size.height * 0.05,
                  opacity: const AlwaysStoppedAnimation(.3),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  weatherForecastDetails.currentWeatherDetails?.weatherText !=
                          null
                      ? weatherForecastDetails
                          .currentWeatherDetails!.weatherText!
                          .toUpperCase()
                      : "N/A",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat ',
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 120,
                  child: Card(
                    child: Stack(children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          Assets.kEarthLines,
                          height: MediaQuery.of(context).size.height * 0.12,
                          opacity: const AlwaysStoppedAnimation(.3),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            Assets.kMaxTemperature,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            opacity:
                                                const AlwaysStoppedAnimation(
                                                    .3),
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          ),
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .dailyForecastsList?[0]
                                                      .maxTemperature !=
                                                  null
                                              ? weatherForecastDetails
                                                  .dailyForecastsList![0]
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
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            Assets.kMinTemperature,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                            opacity:
                                                const AlwaysStoppedAnimation(
                                                    .3),
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          ),
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .dailyForecastsList?[0]
                                                      .minTemperature !=
                                                  null
                                              ? weatherForecastDetails
                                                  .dailyForecastsList![0]
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Wind Direction",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            color: Color.fromRGBO(
                                                110, 110, 114, 1),
                                            fontFamily: 'Pilat ',
                                            fontSize: 8,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .currentWeatherDetails
                                                      ?.windDirection !=
                                                  null
                                              ? weatherForecastDetails
                                                  .currentWeatherDetails!
                                                  .windDirection!
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Wind Speed",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            color: Color.fromRGBO(
                                                110, 110, 114, 1),
                                            fontFamily: 'Pilat ',
                                            fontSize: 8,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .currentWeatherDetails
                                                      ?.windSpeed !=
                                                  null
                                              ? weatherForecastDetails
                                                  .currentWeatherDetails!
                                                  .windSpeed!
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Humidity",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            color: Color.fromRGBO(
                                                110, 110, 114, 1),
                                            fontFamily: 'Pilat ',
                                            fontSize: 8,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .currentWeatherDetails
                                                      ?.humidity !=
                                                  null
                                              ? weatherForecastDetails
                                                  .currentWeatherDetails!
                                                  .humidity!
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Rain Probability",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            color: Color.fromRGBO(
                                                110, 110, 114, 1),
                                            fontFamily: 'Pilat ',
                                            fontSize: 8,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .dailyForecastsList?[0]
                                                      .rainProbability !=
                                                  null
                                              ? "${weatherForecastDetails.dailyForecastsList![0].rainProbability!} %"
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
                Container(
                  height: 230,
                  child: Card(
                    child: Stack(children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          Assets.kEarthLines,
                          height: MediaQuery.of(context).size.height * 0.15,
                          opacity: const AlwaysStoppedAnimation(.3),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (weatherForecastDetails.dailyForecastsList != null)
                            ...buildContent()
                        ],
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.WEATHER_FORECAST_DETAILS, arguments: {
                      "weatherForecastDetails": weatherForecastDetails,
                      "showedPort": showedPort,
                      "updateData": updateData
                    });
                  },
                  child: Text(
                    "5-Day Forecast",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Pilat Heavy',
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: Text("An Error Occured While Rendering Data"),
          );
  }
}
