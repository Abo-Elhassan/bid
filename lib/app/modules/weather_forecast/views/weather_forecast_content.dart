import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WeatherForecastContent extends StatefulWidget {
  @override
  State<WeatherForecastContent> createState() => _WeatherForecastContentState();
}

class _WeatherForecastContentState extends State<WeatherForecastContent> {
  late bool isLoading = false;
  late FilterDataResponse filterData = FilterDataResponse();
  late List<Port> portList = <Port>[];
  late WeatherForecastResponse weatherForecastDetails =
      WeatherForecastResponse();
  late Port? showedPort = Port();

  Future<void> getFilterData() async {
    final filterBody = FilterDataRequest(
        filterTypeUno: 3,
        languageUno: 1033,
        userUno: Helpers.getCurrentUser().userUno,
        companyUno: 1,
        condition: 0);

    filterData =
        await Get.find<WidgetDataProvider>().getBIDFilterData(filterBody);
    if (filterData.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (filterData.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  Future<void> getWeatherData() async {
    final weatherBody = WeatherForecastRequest(
        locationID: showedPort!.locationID.toString(),
        PortUno: Helpers.getCurrentUser().defaultPortUno,
        userUno: Helpers.getCurrentUser().userUno,
        companyUno: 1,
        condition: 0);

    weatherForecastDetails = await Get.find<WeatherForecastProvider>()
        .getWeatherForecastDetails(weatherBody);

    if (weatherForecastDetails.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (weatherForecastDetails.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  void fetchData(bool isInit) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (await Helpers.checkConnectivity()) {
        await getFilterData();

        portList = filterData.portList!;

        if (isInit) {
          showedPort = portList.firstWhereOrNull((port) =>
              port.portUno == Helpers.getCurrentUser().defaultPortUno);
        }
        if (showedPort == null) {
          await Helpers.dialog(
              Icons.error, Colors.red, 'Default Port Data Not Found');
          setState(() {
            isLoading = false;
          });
          return;
        }

        await getWeatherData();
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(true);
  }

  List<Widget> buildContent() {
    return [
      ListTile(
        leading: Image.asset(
          "assets/icons/${weatherForecastDetails.dailyForecastsList![1].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
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
          "assets/icons/${weatherForecastDetails.dailyForecastsList![2].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
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
          "assets/icons/${weatherForecastDetails.dailyForecastsList![3].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchData(false);
            },
          ),
        ],
      ),
      drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchData(false);
        },
        child: Visibility(
          visible: isLoading == false,
          replacement: Helpers.loadingIndicator(),
          child: weatherForecastDetails.statusCode == 200
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.white,
                        value: showedPort?.portName,
                        icon: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Colors.black,
                        ),
                        items: portList.map<DropdownMenuItem<String>>((wid) {
                          return DropdownMenuItem(
                            value: wid.portName,
                            child: Text(
                              wid.portName != null ? wid.portName! : "N/A",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Heavy',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            showedPort = portList.firstWhere(
                                (item) => item.portName == newValue);
                            fetchData(false);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        weatherForecastDetails
                                    .currentWeatherDetails?.temperature !=
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
                        "assets/icons/${weatherForecastDetails.currentWeatherDetails?.weatherIcon}.png",
                        height: MediaQuery.of(context).size.height * 0.05,
                        opacity: const AlwaysStoppedAnimation(.3),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        weatherForecastDetails
                                    .currentWeatherDetails?.weatherText !=
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
                                "assets/images/earth icon.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                opacity: const AlwaysStoppedAnimation(.3),
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image.asset(
                                                  "assets/icons/SUN.png",
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
                                                            .dailyForecastsList?[
                                                                0]
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
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image.asset(
                                                  "assets/icons/MOON.png",
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
                                                            .dailyForecastsList?[
                                                                0]
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
                                                            .dailyForecastsList?[
                                                                0]
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
                                "assets/images/earth icon.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                opacity: const AlwaysStoppedAnimation(.3),
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (weatherForecastDetails.dailyForecastsList !=
                                    null)
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
                          Get.toNamed(Routes.WEATHER_FORECAST_DETAILS,
                              arguments: weatherForecastDetails);
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
                ),
        ),
      ),
    );
  }
}
