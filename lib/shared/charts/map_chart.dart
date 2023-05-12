import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/enums/filter_type.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/shared/charts/geo_json.dart';
import 'package:bid_app/shared/charts/google_map_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:syncfusion_flutter_maps/maps.dart';

class MapChart extends StatefulWidget {
  final Function renderWidgets;
  final Function showCharts;
  final Function autoScroll;
  final Function showChatGPTAnswer;
  final FilterDataResponse filterData;
  final List<Country> countries;
  MapChart(
      {required this.renderWidgets,
      required this.showCharts,
      required this.autoScroll,
      required this.showChatGPTAnswer,
      required this.countries,
      required this.filterData});

  @override
  State<MapChart> createState() => _MapChartState();
}

class _MapChartState extends State<MapChart> {
  late GoogleMapController mapController;

  late Set<Polygon> colorizedPolygons = <Polygon>{}; //contrller for Google map
  late Set<Marker> markers = new Set(); //markers for google map
  late double zoomLevel = 0.0;
  late LatLng currentLocation = LatLng(0, 25.8025);

  late bool isZoomed = false;

//location to show in map

  @override
  void initState() {
    addPolygons();

    super.initState();
  }

  void addPolygons() {
    for (var country in widget.filterData.countryList!
        .where((con) => con.coordinates != null)) {
      var polygon = Polygon(
          polygonId: PolygonId(country.countryUno.toString()),
          points: country.coordinates != null
              ? getCountryPoints(country.coordinates!)
              : [],
          consumeTapEvents: true,
          strokeColor: Colors.grey,
          strokeWidth: 1,
          fillColor: Color.fromRGBO(
            math.Random().nextInt(255),
            math.Random().nextInt(255),
            math.Random().nextInt(255),
            1,
          ),
          onTap: () async {
            if (mounted) {
              widget.autoScroll();
              widget.showCharts(true);
            }

            final request = WidgetDataRequest(
              regionUno: country.regionUno.toString(),
              countryUno: country.countryUno.toString(),
              portUno: "",
              terminalUno: "",
              operatorUno: "",
              widgetTypeUno: "",
              companyUno: 1,
              userUno: Helpers.getCurrentUser().userUno,
              condition: 0,
            );
            widget.renderWidgets(
              widgetDatarequest: request,
              sentRenderType: 1,
              field: country.countryName.toString(),
              filter: FilterType.country,
            );
            if (mounted) {
              setState(() {
                markers = new Set();
                addMarkers(country.countryUno);
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(
                          country.latitude.toDouble(),
                          country.longitude.toDouble(),
                        ),
                        zoom: zoomLevel >= 4 ? zoomLevel : 4)));
              });
            }
          });

      colorizedPolygons.add(polygon);
    }
  }

  List<LatLng> getCountryPoints(List<List<double>> countryCoordinates) {
    late List<LatLng> countryPoints = <LatLng>[];
    countryCoordinates.asMap().forEach((i, point) {
      var ltlng = LatLng(countryCoordinates[i][1], countryCoordinates[i][0]);
      countryPoints.add(ltlng);
    });

    return countryPoints;
  }

  void addMarkers(int selectedCountryUno) {
    //markers to place on map
    for (var port in widget.filterData.portList!.where((por) =>
        por.latitude != 0 &&
        por.longitude != 0 &&
        por.countryUno == selectedCountryUno)) {
      markers.add(Marker(
          //add first marker
          markerId: MarkerId(port.portUno.toString()),
          position: LatLng(
            port.latitude.toDouble(),
            port.longitude.toDouble(),
          ), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: port.portName,
            //snippet: '1  Subtitle',
          ),
          icon: BitmapDescriptor.defaultMarker,
          zIndex: 0,
          onTap: () async {
            if (mounted) {
              widget.autoScroll();
              widget.showCharts(true);
            }

            var country = widget.filterData.countryList!
                .firstWhere((con) => con.countryUno == port.countryUno);
            final request = WidgetDataRequest(
              regionUno: country.regionUno.toString(),
              countryUno: port.countryUno.toString(),
              portUno: port.portUno.toString(),
              terminalUno: "",
              operatorUno: "",
              widgetTypeUno: "",
              companyUno: 1,
              userUno: Helpers.getCurrentUser().userUno,
              condition: 0,
            );

            widget.renderWidgets(
              widgetDatarequest: request,
              sentRenderType: 2,
              field: port.portName.toString(),
              filter: FilterType.port,
            );
          }

          //Icon for Marker
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.width * 0.05)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                bottom: 22,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              GoogleMap(
                onTap: (argument) {
                  setState(() {});
                },
                zoomControlsEnabled: true,
                minMaxZoomPreference: MinMaxZoomPreference(0, 30),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                onCameraMove: (position) {
                  setState(() {
                    zoomLevel = position.zoom;
                  });
                },
                //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition(
                  //innital position in map
                  target: currentLocation, //initial position
                  zoom: zoomLevel, //initial zoom level
                ),
                scrollGesturesEnabled: true,

                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
                polygons: colorizedPolygons,

                markers: zoomLevel >= 4 ? markers : {}, //markers to show on map
                mapType: MapType.hybrid, //map type
                onMapCreated: (controller) {
                  //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
