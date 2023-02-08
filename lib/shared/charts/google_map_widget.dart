import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/shared/charts/geo_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final FilterDataResponse filterData;
  GoogleMapWidget(this.filterData);
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
  late List<LatLng> point = <LatLng>[];
  late Set<Polygon> polygon = <Polygon>{}; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map
  late double zoomLevel = 0.0;
  late LatLng currentLocation = LatLng(26.8206, 30.8025);

  late bool isZoomed = false;
  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId("SA"),
      center: LatLng(23.8859, 45.0792),
      fillColor: Colors.blue.shade100.withOpacity(0.5),
      strokeColor: Colors.blue.shade100.withOpacity(0.1),
      radius: 40000000000,
    )
  ]);
//location to show in map

  @override
  void initState() {
    getmarkers();
    addPoints();
    List<Polygon> addPolygon = [
      Polygon(
          polygonId: PolygonId(widget.filterData.countryList!
              .firstWhere((country) => country.countryUno == 121)
              .countryUno
              .toString()),
          points: point,
          consumeTapEvents: true,
          strokeColor: Colors.grey,
          strokeWidth: 1,
          fillColor: Colors.redAccent,
          onTap: () {
            setState(() {
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(23.8859, 45.0792), zoom: 4)));
            });
          }),
    ];
    polygon.addAll(addPolygon);
    super.initState();
  }

  void addPoints() {
    for (var i = 0; i < GeoJson.SA.length; i++) {
      var ltlng = LatLng(GeoJson.SA[i][1], GeoJson.SA[i][0]);
      point.add(ltlng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      minMaxZoomPreference: MinMaxZoomPreference(0, 18),
      onTap: (argument) {
        setState(() {
          isZoomed = true;
          print(argument);
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: argument, zoom: 4)));
        });
      },
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
      myLocationEnabled: true,

      myLocationButtonEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      polygons: polygon,
      circles: circles,
      markers: zoomLevel >= 4 ? markers : {}, //markers to show on map
      mapType: MapType.hybrid, //map type
      onMapCreated: (controller) {
        //method called when map is created
        setState(() {
          mapController = controller;
        });
      },
    );
  }

  void getmarkers() {
    //markers to place on map

    markers.add(Marker(
        //add first marker
        markerId: MarkerId("1"),
        position: LatLng(21.4669, 39.1744), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Jeddah Port',
          //snippet: '1  Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker,
        zIndex: 0,
        onTap: () async {
          print("First");
        }

        //Icon for Marker
        ));
  }
}
