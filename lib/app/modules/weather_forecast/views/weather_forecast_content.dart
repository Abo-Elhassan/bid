import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/dashboard_provider.dart';
import 'package:bid_app/shared/dropdown_list.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
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
        visualDensity: VisualDensity(vertical: -4),
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastList![1].weatherIcon),
          width: MediaQuery.of(Get.context!).size.width * 0.08,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "Tomorrow - ${weatherForecastDetails.dailyForecastList![1].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastList![1].maxTemperature} / ${weatherForecastDetails.dailyForecastList![1].minTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        visualDensity: VisualDensity(vertical: -4),
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastList![2].weatherIcon),
          width: MediaQuery.of(Get.context!).size.width * 0.08,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(weatherForecastDetails.dailyForecastList![2].observationTimeEpochUTC.toString()) * 1000))} - ${weatherForecastDetails.dailyForecastList![2].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastList![2].maxTemperature} / ${weatherForecastDetails.dailyForecastList![2].minTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        visualDensity: VisualDensity(vertical: -4),
        leading: Image.asset(
          Assets.weatherIcon(
              weatherForecastDetails.dailyForecastList![3].weatherIcon),
          width: MediaQuery.of(Get.context!).size.width * 0.08,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(weatherForecastDetails.dailyForecastList![3].observationTimeEpochUTC.toString()) * 1000))} - ${weatherForecastDetails.dailyForecastList![3].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${weatherForecastDetails.dailyForecastList![3].maxTemperature} / ${weatherForecastDetails.dailyForecastList![3].minTemperature}",
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
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
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
                  height: mediaQuery.size.height * 0.03,
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
                  height: mediaQuery.size.height * 0.01,
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
                  height: mediaQuery.size.height * 0.01,
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
                  height: mediaQuery.size.height * 0.03,
                ),
                Container(
                  height: mediaQuery.size.height * 0.17,
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
                                                      .dailyForecastList?[0]
                                                      .maxTemperature !=
                                                  null
                                              ? weatherForecastDetails
                                                  .dailyForecastList![0]
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
                                                      .dailyForecastList?[0]
                                                      .minTemperature !=
                                                  null
                                              ? weatherForecastDetails
                                                  .dailyForecastList![0]
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
                                height: mediaQuery.size.height * 0.01,
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
                                          height: mediaQuery.size.height * 0.01,
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
                                          height: mediaQuery.size.height * 0.01,
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
                                          height: mediaQuery.size.height * 0.01,
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
                                          height: mediaQuery.size.height * 0.01,
                                        ),
                                        Text(
                                          weatherForecastDetails
                                                      .dailyForecastList?[0]
                                                      .rainProbability !=
                                                  null
                                              ? "${weatherForecastDetails.dailyForecastList![0].rainProbability!} %"
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
                  height: mediaQuery.size.height * 0.25,
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
                          if (weatherForecastDetails.dailyForecastList != null)
                            ...buildContent()
                        ],
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.03,
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
            child: Text("Default Port Not Found"),
          );
  }
}
