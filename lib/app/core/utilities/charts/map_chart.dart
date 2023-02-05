import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:syncfusion_flutter_maps/maps.dart';

class MapChart extends StatefulWidget {
  final List<Country> countries;
  MapChart(this.countries);

  @override
  State<MapChart> createState() => _MapChartState();
}

class _MapChartState extends State<MapChart> {
  late List<Model> data = <Model>[];
  late MapShapeSource dataSource;
  late MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    focalLatLng: MapLatLng(5.1751, 30.0421),
    zoomLevel: 3.5,
  );
  late bool isLoading = true;

  Future<void> fetchData() async {
    if (widget.countries.isNotEmpty &&
        widget.countries.any((country) => country.isSelected)) {
      final selectedContries =
          widget.countries.where((country) => country.isSelected).toList();

      for (var country in selectedContries) {
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

        // _zoomPanBehavior = MapZoomPanBehavior(
        //   focalLatLng: MapLatLng(5.1751, 20.0421),
        //   zoomLevel: 3.5,
        // );
      }
      dataSource = MapShapeSource.asset(
        Assets.kWorldMap,
        shapeDataField: 'name',
        dataCount: data.length,
        primaryValueMapper: (int index) => data[index].country,
        //  dataLabelMapper: (int index) => data[index].countryCode,
        shapeColorValueMapper: (int index) => data[index].color,
      );
    } else {
      data = <Model>[];
      dataSource = MapShapeSource.asset(
        Assets.kWorldMap,
        shapeDataField: 'name',
        dataCount: data.length,
        // primaryValueMapper: (int index) => data[index].country,
        // //  dataLabelMapper: (int index) => data[index].countryCode,
        // shapeColorValueMapper: (int index) => data[index].color,
      );
    }
  }

  @override
  void initState() {
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Helpers.loadingIndicator();
                  } else {
                    return Text("No Data Found");
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
