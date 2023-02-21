// import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
// import 'package:bid_app/shared/charts/geo_json.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapWidget extends StatefulWidget {
//   final FilterDataResponse filterData;
//   GoogleMapWidget(this.filterData);
//   @override
//   _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
// }

// class _GoogleMapWidgetState extends State<GoogleMapWidget> {
//   late GoogleMapController mapController;
//   late List<LatLng> point = <LatLng>[];
//   late Set<Polygon> polygon = <Polygon>{}; //contrller for Google map
//   final Set<Marker> markers = new Set(); //markers for google map
//   late double zoomLevel = 0.0;
//   late LatLng currentLocation = LatLng(26.8206, 30.8025);

//   late bool isZoomed = false;
//   Set<Circle> circles = Set.from([
//     Circle(
//       circleId: CircleId("SA"),
//       center: LatLng(23.8859, 45.0792),
//       fillColor: Colors.blue.shade100.withOpacity(0.5),
//       strokeColor: Colors.blue.shade100.withOpacity(0.1),
//       radius: 40000000000,
//     )
//   ]);
// //location to show in map

//   @override
//   void initState() {
//     getmarkers();
//     addPoints();
//     List<Polygon> addPolygon = [
//       Polygon(
//           polygonId: PolygonId(widget.filterData.countryList!
//               .firstWhere((country) => country.countryUno == 121)
//               .countryUno
//               .toString()),
//           points: point,
//           consumeTapEvents: true,
//           strokeColor: Colors.grey,
//           strokeWidth: 1,
//           fillColor: Colors.redAccent,
//           onTap: () {
//             setState(() {
//               mapController.animateCamera(CameraUpdate.newCameraPosition(
//                   CameraPosition(target: LatLng(23.8859, 45.0792), zoom: 4)));
//             });
//           }),
//     ];
//     polygon.addAll(addPolygon);
//     super.initState();
//   }

//   void addPoints() {
//     for (var i = 0; i < GeoJson.SA.length; i++) {
//       var ltlng = LatLng(GeoJson.SA[i][1], GeoJson.SA[i][0]);
//       point.add(ltlng);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       minMaxZoomPreference: MinMaxZoomPreference(0, 18),
//       onTap: (argument) {
//         setState(() {
//           isZoomed = true;
//           print(argument);
//           mapController.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(target: argument, zoom: 4)));
//         });
//       },
//       onCameraMove: (position) {
//         setState(() {
//           zoomLevel = position.zoom;
//         });
//       },
//       //Map widget from google_maps_flutter package
//       zoomGesturesEnabled: true, //enable Zoom in, out on map
//       initialCameraPosition: CameraPosition(
//         //innital position in map
//         target: currentLocation, //initial position
//         zoom: zoomLevel, //initial zoom level
//       ),
//       scrollGesturesEnabled: true,
//       myLocationEnabled: true,

//       myLocationButtonEnabled: true,
//       gestureRecognizers: Set()
//         ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
//       polygons: polygon,
//       circles: circles,
//       markers: zoomLevel >= 4 ? markers : {}, //markers to show on map
//       mapType: MapType.hybrid, //map type
//       onMapCreated: (controller) {
//         //method called when map is created
//         setState(() {
//           mapController = controller;
//         });
//       },
//     );
//   }

//   void getmarkers() {
//     //markers to place on map

//     markers.add(Marker(
//         //add first marker
//         markerId: MarkerId("1"),
//         position: LatLng(21.4669, 39.1744), //position of marker
//         infoWindow: InfoWindow(
//           //popup info
//           title: 'Jeddah Port',
//           //snippet: '1  Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//         zIndex: 0,
//         onTap: () async {
//           print("First");
//         }

//         //Icon for Marker
//         ));
//   }
// }






// import 'package:bid_app/app/core/utilities/helpers.dart';
// import 'package:bid_app/app/core/values/app_assets.dart';
// import 'package:bid_app/app/modules/home/views/home_content.dart';
// import 'package:bid_app/shared/charts/bid_chart_view.dart';
// import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
// import 'package:bid_app/shared/charts/map_chart.dart';
// import 'package:bid_app/shared/charts/noi_view.dart';
// import 'package:bid_app/shared/page_layout.dart';

// import 'package:bid_app/app/core/utilities/helpers.dart';
// import 'package:bid_app/app/modules/home/views/home_content.dart';
// import 'package:bid_app/shared/page_layout.dart';
// import 'package:bid_app/shared/side_menu.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final mediaQuery = MediaQuery.of(context);

//     List<Widget> widgetsList = [
//       GestureDetector(
//         onVerticalDragUpdate: (_) {},
//         child: MapChart(controller.filterFromMap,
//             controller.filterData.countryList!, controller.filterData),
//       ),
//       SizedBox(
//         height: 50,
//       ),
//       controller.obx(
//         (state) {
//           return Column(
//             children: [
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 FilteredBIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   "GDP",
//                   "GDP",
//                 ),
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 FilteredBIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   "GDPGR",
//                   "GDPGR",
//                 ),
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 FilteredBIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   "POP",
//                   "POPULATION",
//                 ),
//               if (controller.renderType == 0 || controller.renderType == 1)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 FilteredBIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   "VOL",
//                   "VOLUME",
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 BIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   controller.filterData,
//                   "CAPACITY",
//                   "CAPACITY",
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 BIDChartView(
//                   controller.widgetsData.bidWidgetDetails!,
//                   controller.filterData,
//                   "DEVELOPMENT",
//                   "DEVELOPMENT",
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 SizedBox(
//                   height: 50,
//                 ),
//               if (controller.renderType == 2 || controller.renderType == 0)
//                 NatureOfInvlovementView(
//                   controller.widgetsData.bidWidgetDetails!,
//                 ),
//               SizedBox(
//                 height: 50,
//               ),
//             ],
//           );
//         },
//         onLoading: Center(
//           child: Helpers.loadingIndicator(),
//         ),
//         onEmpty: Center(
//           child: Text(
//             "Data Not Found",
//             style: TextStyle(fontFamily: "Pilat Heavy", fontSize: 22),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         onError: (error) => Center(
//           child: Text(
//             error.toString(),
//             textAlign: TextAlign.center,
//             style: TextStyle(fontFamily: "Pilat Heavy", fontSize: 22),
//           ),
//         ),
//       ),
//     ];

//     return Scaffold(
//         key: controller.scaffoldKey,
//         floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               WidgetsBinding.instance.addPostFrameCallback((_) =>
//                   controller.itemController.scrollTo(
//                       index: 0,
//                       duration: Duration(milliseconds: 500),
//                       curve: Curves.linear));
//             },
//             child: Icon(Icons.arrow_upward)),
//         appBar: AppBar(
//           leading: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: Icon(
//                   Icons.menu,
//                   size: MediaQuery.of(context).size.width * 0.06,
//                 ),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//                 tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//               );
//             },
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 Icons.refresh,
//                 size: MediaQuery.of(context).size.width * 0.06,
//               ),
//               onPressed: () async {
//                 controller.refreshData();
//               },
//             ),
//           ],
//         ),
//         drawer: Helpers.getCurrentUser().roleType == 1
//             ? SideMenu(Helpers.getCurrentUser().username.toString())
//             : null,
//         body: GetBuilder<HomeController>(
//           init: HomeController(),
//           builder: (_) => Stack(children: [
//             Positioned(
//               right: -10,
//               top: 150,
//               child: RotatedBox(
//                 quarterTurns: -1,
//                 child: Image.asset(
//                   Assets.kEarthLines,
//                   height: MediaQuery.of(context).size.height * 0.40,
//                   opacity: const AlwaysStoppedAnimation(.5),
//                   fit: BoxFit.cover,
//                   gaplessPlayback: true,
//                 ),
//               ),
//             ),
//             RefreshIndicator(
//               onRefresh: () async {
//                 controller.refreshData();
//               },
//               child: controller.isInitLoading
//                   ? Helpers.loadingIndicator()
//                   : Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: mediaQuery.size.width * 0.05,
//                         vertical: mediaQuery.size.height * 0.01,
//                       ),
//                       child: controller.isFilterDataFetched() &&
//                               controller.isWidgetsDataFetched()
//                           ? Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       controller.selectedRegions.toString(),
//                                       style: TextStyle(
//                                         color: theme.colorScheme.primary,
//                                         fontFamily: 'Pilat Heavy',
//                                         fontSize:
//                                             MediaQuery.of(context).size.width *
//                                                 0.04,
//                                       ),
//                                     ),
//                                     IconButton(
//                                         padding: EdgeInsets.zero,
//                                         visualDensity:
//                                             VisualDensity(horizontal: -4),
//                                         onPressed: () => controller.dialog(),
//                                         icon: Icon(
//                                           Icons.manage_search,
//                                           size: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.07,
//                                         ))
//                                   ],
//                                 ),
//                                 controller.buildGredientLine(
//                                   mediaQuery,
//                                   theme,
//                                 ),
//                                 Expanded(
//                                   child: ScrollablePositionedList.builder(
//                                     padding: EdgeInsets.zero,
//                                     itemScrollController:
//                                         controller.itemController,
//                                     itemCount: 3,
//                                     itemBuilder: (context, index) =>
//                                         widgetsList[index],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Center(child: Text("Internal Error Occured")),
//                     ),
//             ),
//           ]),
//         ));
//   }
// }
