import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:syncfusion_flutter_maps/maps.dart';

class MapChart extends StatefulWidget {
  final List<Country>? countries;
  MapChart(this.countries);

  @override
  State<MapChart> createState() => _MapChartState();
}

class _MapChartState extends State<MapChart> {
  late List<Model> data;
  late MapShapeSource dataSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late bool isLoading = true;

  Future<void> fetchData() async {
    data = <Model>[];
    for (var country in widget.countries!) {
      data.add(
        Model(
            country.countryName!,
            Color.fromRGBO(
              math.Random().nextInt(255),
              math.Random().nextInt(255),
              math.Random().nextInt(255),
              1,
            ),
            country.countryName!),
      );
    }

    dataSource = MapShapeSource.asset(
      'assets/world-map.json',
      shapeDataField: 'name',
      dataCount: data.length,
      primaryValueMapper: (int index) => data[index].country,
      //  dataLabelMapper: (int index) => data[index].countryCode,
      shapeColorValueMapper: (int index) => data[index].color,
    );
    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(5.1751, 20.0421),
      zoomLevel: 3.5,
    );
  }

  @override
  void initState() {
    // data = <Model>[];
    // for (var country in widget.countries!) {
    //   data.add(
    //     Model(
    //         country.countryName!,
    //         Color.fromRGBO(
    //           math.Random().nextInt(255),
    //           math.Random().nextInt(255),
    //           math.Random().nextInt(255),
    //           1,
    //         ),
    //         country.countryName!),
    //   );
    // }

    // dataSource = MapShapeSource.asset(
    //   'assets/world-map.json',
    //   shapeDataField: 'name',
    //   dataCount: data.length,
    //   primaryValueMapper: (int index) => data[index].country,
    //   //  dataLabelMapper: (int index) => data[index].countryCode,
    //   shapeColorValueMapper: (int index) => data[index].color,
    // );
    // _zoomPanBehavior = MapZoomPanBehavior(
    //   focalLatLng: MapLatLng(5.1751, 20.0421),
    //   zoomLevel: 3.5,
    // );
    // setState(() {
    //   isLoading = false;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LOCATION",
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontFamily: 'Pilat Heavy',
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 308,
          width: double.infinity,
          child: Card(
            child: FutureBuilder(
                future: fetchData(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SfMaps(
                      layers: <MapShapeLayer>[
                        MapShapeLayer(
                          zoomPanBehavior: _zoomPanBehavior,
                          source: dataSource,
                          showDataLabels: false,
                          //legend: MapLegend(MapElement.shape),
                          shapeTooltipBuilder:
                              (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(data[index].countryCode),
                            );
                          },
                          tooltipSettings: MapTooltipSettings(
                              color: Colors.white,
                              strokeColor: Colors.white,
                              strokeWidth: 2),
                          strokeColor: Colors.white,
                          strokeWidth: 0.5,
                          dataLabelSettings: MapDataLabelSettings(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8)),
                        ),
                      ],
                    );
                  } else {
                    return Helpers.loadingIndicator();
                  }
                }),
          ),
        ),
      ],
    );
  }
}

class Model {
  Model(this.country, this.color, this.countryCode);

  String country;
  Color color;
  String countryCode;
}
