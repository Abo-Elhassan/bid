import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/responses/weather_forecast_response.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class WidgetSlider extends StatefulWidget {
  final List<DailyForecast> dailyForecastList;
  const WidgetSlider(
    this.dailyForecastList,
  );

  @override
  State<WidgetSlider> createState() => _WidgetSliderState();
}

class _WidgetSliderState extends State<WidgetSlider> {
  final CarouselController carouselController = CarouselController();
  late int current = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGredientLine(MediaQueryData mediaQuery, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.size.height * 0.008,
        bottom: mediaQuery.size.height * 0.03,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 2,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.0),
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary.withOpacity(0.5),
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.5),
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary.withOpacity(0.0),
                ],
                stops: const [
                  0.1,
                  0.2,
                  0.3,
                  0.5,
                  0.7,
                  0.8,
                  0.9,
                ]),
          ),
        ),
      ),
    );
  }

  List<Widget> buildDailyWeatherWidgets(MediaQueryData mediaQuery) {
    return widget.dailyForecastList
        .map(
          (item) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                        height: mediaQuery.size.height * 0.25,
                        opacity: const AlwaysStoppedAnimation(.3),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat("EEEE,  MMM d")
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(item.observationTimeEpochUTC
                                            .toString()) *
                                        1000))
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Pilat Heavy',
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            item.weatherText.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            Assets.weatherIcon(item.weatherIcon),
                            width: 80,
                            opacity: const AlwaysStoppedAnimation(.4),
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      Assets.kMaxTemperature,
                                      height: mediaQuery.size.height * 0.035,
                                      opacity: const AlwaysStoppedAnimation(.4),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                  Text(
                                    item.maxTemperature != null
                                        ? item.maxTemperature!
                                        : "N/A",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Pilat ',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      Assets.kMinTemperature,
                                      height: mediaQuery.size.height * 0.025,
                                      opacity: const AlwaysStoppedAnimation(.4),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                  Text(
                                    item.minTemperature != null
                                        ? item.minTemperature!
                                        : "N/A",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Pilat ',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          buildGredientLine(
                            MediaQuery.of(context),
                            Theme.of(context),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildWeatherListTile(
                                dayForecast: item,
                                icon: Assets.kWindDirection,
                                title: "Wind Direction",
                                content: item.windDirection ?? "N/A",
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              buildWeatherListTile(
                                dayForecast: item,
                                icon: Assets.kWindSpeed,
                                title: "Wind Speed",
                                content: item.windSpeed ?? "N/A",
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              buildWeatherListTile(
                                dayForecast: item,
                                icon: Assets.kHumidity,
                                title: "Humidity",
                                content: item.humidity ?? "N/A",
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              buildWeatherListTile(
                                dayForecast: item,
                                icon: Assets.kRainProbability,
                                title: "Rain Probability",
                                content: item.rainProbability ?? "N/A",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        )
        .toList();
  }

  ListTile buildWeatherListTile({
    required DailyForecast dayForecast,
    required String icon,
    required String title,
    required String content,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          icon,
          width: 40,
          opacity: const AlwaysStoppedAnimation(.4),
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color.fromRGBO(110, 110, 114, 1),
          fontFamily: 'Pilat Light',
        ),
      ),
      trailing: Container(
          alignment: Alignment.centerLeft, width: 80, child: Text(content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CarouselSlider(
            items: buildDailyWeatherWidgets(MediaQuery.of(context)),
            carouselController: carouselController,
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 1.0,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                // enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.dailyForecastList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => carouselController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
