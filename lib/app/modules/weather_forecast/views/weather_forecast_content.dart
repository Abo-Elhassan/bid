import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/shared/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WeatherForecastContent extends StatefulWidget {
  final List<Terminal> terminalList;
  late WeatherForecastResponse weatherForecastDetails;

  WeatherForecastContent(this.terminalList, this.weatherForecastDetails);

  @override
  State<WeatherForecastContent> createState() => _WeatherForecastContentState();
}

class _WeatherForecastContentState extends State<WeatherForecastContent> {
  late Terminal showedTerminal = widget.terminalList[0];

  final localStorage = GetStorage();
  late bool isLoading = false;
  @override
  void initState() {
    showedTerminal = widget.terminalList.firstWhere((terminal) =>
        terminal.terminalUno == Helpers.getCurrentUser().defaultTerminalUno);
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      if (await Helpers.checkConnectivity()) {
        final weatherBody = WeatherForecastRequest(
            locationID: showedTerminal.locationID.toString(),
            terminalUno: Helpers.getCurrentUser().defaultTerminalUno,
            userUno: Helpers.getCurrentUser().userUno,
            companyUno: 1,
            condition: 0);

        widget.weatherForecastDetails =
            await Get.find<WeatherForecastProvider>()
                .getWeatherForecastDetails(weatherBody);

        // if (widget.weatherForecastDetails.statusCode != 200) {
        //   await Helpers.dialog(
        //       Icons.error, Colors.red, 'An Error Occured While Rendering Data');
        //   return;
        // }
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
    } catch (error) {
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  List<Widget> buildContent() {
    return [
      ListTile(
        leading: Image.asset(
          "assets/icons/${widget.weatherForecastDetails.dailyForecastsList![1].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "Tomorrow - ${widget.weatherForecastDetails.dailyForecastsList![1].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${widget.weatherForecastDetails.dailyForecastsList![1].minTemperature} / ${widget.weatherForecastDetails.dailyForecastsList![1].maxTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        leading: Image.asset(
          "assets/icons/${widget.weatherForecastDetails.dailyForecastsList![2].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.weatherForecastDetails.dailyForecastsList![2].observationTimeEpochUTC.toString()) * 1000))} - ${widget.weatherForecastDetails.dailyForecastsList![2].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${widget.weatherForecastDetails.dailyForecastsList![2].minTemperature} / ${widget.weatherForecastDetails.dailyForecastsList![2].maxTemperature}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
      ),
      ListTile(
        leading: Image.asset(
          "assets/icons/${widget.weatherForecastDetails.dailyForecastsList![3].weatherIcon}.png",
          height: MediaQuery.of(context).size.height * 0.035,
          opacity: const AlwaysStoppedAnimation(.3),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
        title: Text(
          "${DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.weatherForecastDetails.dailyForecastsList![3].observationTimeEpochUTC.toString()) * 1000))} - ${widget.weatherForecastDetails.dailyForecastsList![3].weatherText}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pilat ',
            fontSize: 12,
          ),
        ),
        trailing: Text(
          "${widget.weatherForecastDetails.dailyForecastsList![3].minTemperature} / ${widget.weatherForecastDetails.dailyForecastsList![3].maxTemperature}",
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
              onPressed: () async {
                await fetchData();
              },
            ),
          ],
        ),
        drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: fetchData(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Helpers.loadingIndicator();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("error");
                  ;
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton(
                            dropdownColor: Colors.white,
                            value: showedTerminal.terminalName,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Colors.black,
                            ),
                            items: widget.terminalList
                                .map<DropdownMenuItem<String>>((wid) {
                              return DropdownMenuItem(
                                value: wid.terminalName,
                                child: Text(
                                  wid.terminalName != null
                                      ? wid.terminalName!
                                      : "",
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
                                showedTerminal = widget.terminalList.firstWhere(
                                    (item) => item.terminalName == newValue);
                                fetchData();
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.weatherForecastDetails.currentWeatherDetails
                                        ?.temperature !=
                                    null
                                ? '${widget.weatherForecastDetails.currentWeatherDetails!.temperature!} '
                                : "".toString(),
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
                            "assets/icons/${widget.weatherForecastDetails.currentWeatherDetails?.weatherIcon}.png",
                            height: MediaQuery.of(context).size.height * 0.05,
                            opacity: const AlwaysStoppedAnimation(.3),
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.weatherForecastDetails.currentWeatherDetails
                                        ?.weatherText !=
                                    null
                                ? widget.weatherForecastDetails
                                    .currentWeatherDetails!.weatherText!
                                    .toUpperCase()
                                : "",
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
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
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
                                              // ListTile(
                                              //   leading: Text("hfd"),
                                              //   trailing: Text("gfdgd"),
                                              // ),
                                              // ListTile(
                                              //   leading: Text("hfd"),
                                              //   trailing: Text("gfdgd"),
                                              // ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Image.asset(
                                                      "assets/icons/SUN.png",
                                                      height:
                                                          MediaQuery.of(context)
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
                                                    widget
                                                                .weatherForecastDetails
                                                                .dailyForecastsList?[
                                                                    0]
                                                                .maxTemperature !=
                                                            null
                                                        ? widget
                                                            .weatherForecastDetails
                                                            .dailyForecastsList![
                                                                0]
                                                            .maxTemperature!
                                                        : "",
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
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Image.asset(
                                                      "assets/icons/MOON.png",
                                                      height:
                                                          MediaQuery.of(context)
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
                                                    widget
                                                                .weatherForecastDetails
                                                                .dailyForecastsList?[
                                                                    0]
                                                                .minTemperature !=
                                                            null
                                                        ? widget
                                                            .weatherForecastDetails
                                                            .dailyForecastsList![
                                                                0]
                                                            .minTemperature!
                                                        : "",
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
                                                      color: Color.fromRGBO(
                                                          110, 110, 114, 1),
                                                      fontFamily: 'Pilat Light',
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    widget
                                                                .weatherForecastDetails
                                                                .currentWeatherDetails
                                                                ?.windDirection !=
                                                            null
                                                        ? widget
                                                            .weatherForecastDetails
                                                            .currentWeatherDetails!
                                                            .windDirection!
                                                            .toUpperCase()
                                                        : "",
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
                                                    widget
                                                                .weatherForecastDetails
                                                                .currentWeatherDetails
                                                                ?.windSpeed !=
                                                            null
                                                        ? widget
                                                            .weatherForecastDetails
                                                            .currentWeatherDetails!
                                                            .windSpeed!
                                                            .toUpperCase()
                                                        : "",
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
                                                    widget
                                                                .weatherForecastDetails
                                                                .currentWeatherDetails
                                                                ?.humidity !=
                                                            null
                                                        ? widget
                                                            .weatherForecastDetails
                                                            .currentWeatherDetails!
                                                            .humidity!
                                                            .toUpperCase()
                                                        : "",
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
                                                    widget
                                                                .weatherForecastDetails
                                                                .dailyForecastsList?[
                                                                    0]
                                                                .rainProbability !=
                                                            null
                                                        ? "${widget.weatherForecastDetails.dailyForecastsList![0].rainProbability!} %"
                                                        : "",
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
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    opacity: const AlwaysStoppedAnimation(.3),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (widget.weatherForecastDetails
                                            .dailyForecastsList !=
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
                                  arguments: widget.weatherForecastDetails);
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
                    ),
                  );
                }
              }),
        ));
  }
}
