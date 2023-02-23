import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/modules/home/views/home_content.dart';
import 'package:bid_app/shared/charts/bid_chart_view.dart';
import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
import 'package:bid_app/shared/charts/map_chart.dart';
import 'package:bid_app/shared/charts/noi_view.dart';
import 'package:bid_app/shared/page_layout.dart';

import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/modules/home/views/home_content.dart';
import 'package:bid_app/shared/page_layout.dart';
import 'package:bid_app/shared/side_menu.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        key: controller.scaffoldKey,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // controller.scrollController.animateTo(
              //   5,
              //   duration: Duration(milliseconds: 500),
              //   curve: Curves.linear,
              // );

              controller.showMap();
            },
            child: Icon(Icons.map)),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
              onPressed: () async {
                controller.refreshData();
              },
            ),
          ],
        ),
        drawer: Helpers.getCurrentUser().roleType == 1
            ? SideMenu(Helpers.getCurrentUser().username.toString())
            : null,
        body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (_) => Stack(children: [
            Positioned(
              right: -10,
              top: 150,
              child: RotatedBox(
                quarterTurns: -1,
                child: Image.asset(
                  Assets.kEarthLines,
                  height: MediaQuery.of(context).size.height * 0.40,
                  opacity: const AlwaysStoppedAnimation(.5),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                controller.refreshData();
              },
              child: controller.isInitLoading
                  ? Helpers.loadingIndicator()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.05,
                        vertical: mediaQuery.size.height * 0.01,
                      ),
                      child: controller.isFilterDataFetched() &&
                              controller.isWidgetsDataFetched()
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedRegions.toString(),
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontFamily: 'Pilat Heavy',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                    ),
                                    // IconButton(
                                    //     padding: EdgeInsets.zero,
                                    //     visualDensity:
                                    //         VisualDensity(horizontal: -4),
                                    //     onPressed: () {
                                    //       controller.showMap(true);
                                    //     },
                                    //     icon: Icon(
                                    //       Icons.map,
                                    //       size: MediaQuery.of(context)
                                    //               .size
                                    //               .width *
                                    //           0.07,
                                    //     )),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        visualDensity:
                                            VisualDensity(horizontal: -4),
                                        onPressed: () => controller.dialog(),
                                        icon: Icon(
                                          Icons.manage_search,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ))
                                  ],
                                ),
                                controller.buildGredientLine(
                                  mediaQuery,
                                  theme,
                                ),
                                GetBuilder<HomeController>(
                                  init: HomeController(),
                                  builder: (controller) => Expanded(
                                    child: SingleChildScrollView(
                                      physics: controller.isChartsVisible
                                          ? null
                                          : NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      controller: controller.scrollController,
                                      child: Column(
                                        children: [
                                          if (controller.isMapVisible)
                                            MapChart(
                                              controller.filterFromMap,
                                              controller.showCharts,
                                              controller.autoScroll,
                                              controller
                                                  .filterData.countryList!,
                                              controller.filterData,
                                            ),
                                          if (controller.isChartsVisible)
                                            SizedBox(
                                              height: 50,
                                            ),
                                          if (controller.isChartsVisible)
                                            controller.obx(
                                              (state) {
                                                return Column(
                                                  children: [
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      FilteredBIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        "GDP",
                                                        "GDP",
                                                      ),
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      FilteredBIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        "GDPGR",
                                                        "GDPGR",
                                                      ),
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      FilteredBIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        "POP",
                                                        "POPULATION",
                                                      ),
                                                    if (controller.renderType ==
                                                            0 ||
                                                        controller.renderType ==
                                                            1)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      FilteredBIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        "VOL",
                                                        "VOLUME",
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      BIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        controller.filterData,
                                                        "CAPACITY",
                                                        "CAPACITY",
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      BIDChartView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                        controller.filterData,
                                                        "DEVELOPMENT",
                                                        "DEVELOPMENT",
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      SizedBox(
                                                        height: 50,
                                                      ),
                                                    if (controller.renderType ==
                                                            2 ||
                                                        controller.renderType ==
                                                            0)
                                                      NatureOfInvlovementView(
                                                        controller.widgetsData
                                                            .bidWidgetDetails!,
                                                      ),
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                  ],
                                                );
                                              },
                                              onLoading: Center(
                                                child:
                                                    Helpers.loadingIndicator(),
                                              ),
                                              onEmpty: Center(
                                                child: Text(
                                                  "Data Not Found",
                                                  style: TextStyle(
                                                      fontFamily: "Pilat Heavy",
                                                      fontSize: 22),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              onError: (error) => Center(
                                                child: Text(
                                                  error.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Pilat Heavy",
                                                      fontSize: 22),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Center(child: Text("Internal Error Occured")),
                    ),
            ),
          ]),
        ));
  }
}
