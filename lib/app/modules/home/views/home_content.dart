import 'package:bid_app/app/data/models/requests/filter_data_request.dart';

import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';

import 'package:bid_app/app/data/models/responses/widget_data_response.dart';

import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/charts/bid_chart_view.dart';
import 'package:bid_app/app/data/utilities/charts/bid_chart_without_filter.dart';

import 'package:bid_app/app/data/utilities/charts/bid_chart.dart';
import 'package:bid_app/app/data/utilities/charts/bid_chart_without_filter_view.dart';

import 'package:bid_app/app/data/utilities/charts/nature_of_involvement.dart';

import 'package:bid_app/shared/helpers.dart';
import 'package:bid_app/app/data/utilities/charts/map_chart.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class HomeContent extends StatefulWidget {
  // final Function fetchData;
  // const HomeContent({required this.fetchData});
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final localStorage = GetStorage();
  late WidgetDataResponse widgetsData = WidgetDataResponse();
  late FilterDataResponse filterData = FilterDataResponse();
  StringBuffer selectedRegions = StringBuffer();
  bool isLoading = false;
  bool isDataUpdated = false;
  bool isRegionFilterVisible = false;
  bool isCountryFilterVisible = false;
  bool isPortFilterVisible = false;
  bool isTerminalFilterVisible = false;
  bool isOperatorFilterVisible = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void getSelectedRegion() {
    selectedRegions.clear();
    for (var region in filterData.regionList!.where((reg) => reg.isSelected)) {
      if (region ==
          filterData.regionList!.where((reg) => reg.isSelected).toList()[
              filterData.regionList!.where((reg) => reg.isSelected).length -
                  1]) {
        selectedRegions.write('${region.regionCode} ');
      } else {
        selectedRegions.write('${region.regionCode}, ');
      }
    }
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Helpers.checkConnectivity()) {
        if (isDataUpdated == false) {
          await getFilterData();
        }
        getSelectedRegion();
        await getWidgetData();
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  void refreshData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Helpers.checkConnectivity()) {
        if (filterData.regionList!.any((reg) => reg.isSelected) &&
            filterData.countryList!.any((cont) => cont.isSelected)) {
          getWidgetData();
          getSelectedRegion();
        } else {
          Helpers.dialog(Icons.error, Colors.red,
              'You have to select one country at least to get data');
          setState(() {
            isLoading = false;
          });
          return;
        }
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  bool isFilterDatafetched() {
    if (filterData.regionList != null &&
        filterData.countryList != null &&
        filterData.portList != null &&
        filterData.terminalList != null &&
        filterData.operatorList != null) {
      if (filterData.regionList!.isNotEmpty &&
          filterData.countryList!.isNotEmpty &&
          filterData.portList!.isNotEmpty &&
          filterData.terminalList!.isNotEmpty &&
          filterData.operatorList!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isWidgetsDataFetched() {
    if (widgetsData.bidWidgetDetails != null) {
      if (widgetsData.bidWidgetDetails!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> getFilterData() async {
    final filterRequestBody = FilterDataRequest(
        filterTypeUno: 0,
        languageUno: 1033,
        userUno: Helpers.getCurrentUser().userUno,
        companyUno: 1,
        condition: 0);

    filterData = await Get.find<WidgetDataProvider>()
        .getBIDFilterData(filterRequestBody);
    if (filterData.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (filterData.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  Future<void> getWidgetData() async {
    final widgetRequestBody = prepareWidgetDataBody();

    widgetsData = await Get.find<WidgetDataProvider>()
        .getBIDashboardWidgetData(widgetRequestBody);

    if (widgetsData.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (widgetsData.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  WidgetDataRequest prepareWidgetDataBody() {
    if (filterData.terminalList!.isEmpty ||
        filterData.portList!.isEmpty ||
        filterData.regionList!.isEmpty ||
        filterData.countryList!.isEmpty ||
        filterData.operatorList!.isEmpty) {
      return WidgetDataRequest(
          regionUno: "",
          countryUno: "",
          portUno: "",
          terminalUno: "",
          operatorUno: "",
          widgetTypeUno: "",
          companyUno: 0,
          userUno: 0,
          condition: 0);
    }

    var regionUnoBody = StringBuffer();
    var countryUnoBody = StringBuffer();
    var portUnoBody = StringBuffer();
    var terminalUnoBody = StringBuffer();
    var operatorUnoBody = StringBuffer();

    for (var region in filterData.regionList!.where((reg) => reg.isSelected)) {
      regionUnoBody.write('${region.regionUno},');
      if (filterData.regionList?[filterData.regionList!.length - 1] == region) {
        regionUnoBody.write(region.regionUno);
      }
    }

    for (var country
        in filterData.countryList!.where((con) => con.isSelected)) {
      countryUnoBody.write('${country.countryUno},');
      if (filterData.countryList?[filterData.countryList!.length - 1] ==
          country) {
        countryUnoBody.write(country.countryUno);
      }
    }

    for (var port in filterData.portList!.where((por) => por.isSelected)) {
      portUnoBody.write('${port.portUno},');
      if (filterData.portList?[filterData.portList!.length - 1] == port) {
        portUnoBody.write(port.portUno);
      }
    }

    for (var terminal
        in filterData.terminalList!.where((ter) => ter.isSelected)) {
      terminalUnoBody.write('${terminal.terminalUno},');
      if (filterData.terminalList?[filterData.terminalList!.length - 1] ==
          terminal) {
        terminalUnoBody.write(terminal.terminalUno);
      }
    }
    for (var operator
        in filterData.operatorList!.where((op) => op.isSelected)) {
      operatorUnoBody.write('${operator.operatorUno},');
      if (filterData.operatorList?[filterData.operatorList!.length - 1] ==
          operator) {
        operatorUnoBody.write(operator.operatorUno);
      }
    }

    final requestBody = WidgetDataRequest(
        regionUno: regionUnoBody.toString(),
        countryUno: countryUnoBody.toString(),
        portUno: portUnoBody.toString(),
        terminalUno: terminalUnoBody.toString(),
        operatorUno: operatorUnoBody.toString(),
        widgetTypeUno: "",
        companyUno: 1,
        userUno: Helpers.getCurrentUser().userUno,
        condition: 0);

    return requestBody;
  }

  Future<void> dialog() async {
    isRegionFilterVisible = false;
    isCountryFilterVisible = false;
    isPortFilterVisible = false;
    isTerminalFilterVisible = false;
    isOperatorFilterVisible = false;
    await showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, setState) {
            return SimpleDialog(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(Get.context!).size.width * 0.04,
                      vertical: MediaQuery.of(Get.context!).size.width * 0.02),
                  width: double.infinity,
                  // child:
                  //  Container(
                  //   height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FILTER",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Pilat Heavy',
                              fontSize: 14,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isRegionFilterVisible = !isRegionFilterVisible;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "REGION",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                          ),
                          if (isRegionFilterVisible)
                            buildRegionFilter(setState),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isCountryFilterVisible =
                                    !isCountryFilterVisible;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "COUNRTY",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                          ),
                          if (isCountryFilterVisible)
                            buildCountryFilter(setState),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isPortFilterVisible = !isPortFilterVisible;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "PORT",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                          ),
                          if (isPortFilterVisible) buildPortFilter(setState),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isTerminalFilterVisible =
                                    !isTerminalFilterVisible;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "TERMINAL",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                          ),
                          if (isTerminalFilterVisible)
                            buildTerminalFilter(setState),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isOperatorFilterVisible =
                                    !isOperatorFilterVisible;
                              });
                            },
                            visualDensity: VisualDensity(
                              vertical: -4,
                            ),
                            leading: Text(
                              "OPERATOR",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                          ),
                          if (isOperatorFilterVisible)
                            buildOperatorFilter(setState),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      filterData.regionList?.forEach(
                                          (region) => region.isSelected = true);
                                      filterData.countryList?.forEach(
                                          (country) =>
                                              country.isSelected = true);
                                      filterData.portList?.forEach(
                                          (port) => port.isSelected = true);
                                      filterData.terminalList?.forEach(
                                          (terminal) =>
                                              terminal.isSelected = true);
                                      filterData.operatorList?.forEach(
                                          (operator) =>
                                              operator.isSelected = true);
                                    },
                                  );
                                },
                                child: Text(
                                  "Reset Filter",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Pilat Demi',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    refreshData();
                                  });
                                  Get.back();
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ),
                ),
              ],
            );
          });
        });
  }

  Column buildRegionFilter(StateSetter setState) {
    if (filterData.regionList == null) {
      return Column();
    }

    return Column(
      children: filterData.regionList!.map((reg) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(
                Colors.black,
              ),
              value: reg.isSelected,
              onChanged: (bool? val) {
                setState(() {
                  reg.isSelected = val!;
                });
              },
            ),
            Text(reg.regionCode!),
          ],
        );
      }).toList(),
    );
  }

  Column buildCountryFilter(StateSetter setState) {
    if (filterData.countryList == null || filterData.regionList == null) {
      return Column();
    }
    for (var country in filterData.countryList!) {
      if (filterData.regionList!
          .any((reg) => reg.isSelected && reg.regionUno == country.regionUno)) {
        setState(
          () {
            country.isRegionSelected = true;
          },
        );
      } else {
        setState(
          () {
            country.isRegionSelected = false;
            country.isSelected = false;
          },
        );
      }
    }

    return Column(
      children: filterData.countryList!
          .where((country) => filterData.regionList!.any(
              (reg) => reg.isSelected && reg.regionUno == country.regionUno))
          .map((con) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(
                Colors.black,
              ),
              value: con.isSelected,
              onChanged: (bool? val) {
                setState(() {
                  con.isSelected = val!;
                });
              },
            ),
            Text(con.countryCode!),
          ],
        );
      }).toList(),
    );
  }

  Column buildPortFilter(StateSetter setState) {
    if (filterData.countryList == null || filterData.portList == null) {
      return Column();
    }

    for (var port in filterData.portList!) {
      if (filterData.countryList!
          .any((con) => con.isSelected && con.countryUno == port.countryUno)) {
        setState(
          () {
            port.isCountrySelected = true;
          },
        );
      } else {
        setState(
          () {
            port.isCountrySelected = false;
            port.isSelected = false;
          },
        );
      }
    }
    return Column(
      children: filterData.portList!
          .where((port) => filterData.countryList!.any((con) =>
              con.isSelected &&
              con.countryUno == port.countryUno &&
              filterData.regionList!.any(
                  (reg) => reg.isSelected && reg.regionUno == con.regionUno)))
          .map((por) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(
                Colors.black,
              ),
              value: por.isSelected,
              onChanged: (bool? val) {
                setState(() {
                  por.isSelected = val!;
                });
              },
            ),
            Text(por.portCode!),
          ],
        );
      }).toList(),
    );
  }

  Column buildTerminalFilter(StateSetter setState) {
    if (filterData.terminalList == null || filterData.portList == null) {
      return Column();
    }

    for (var terminal in filterData.terminalList!) {
      if (filterData.portList!
          .any((port) => port.isSelected && port.portUno == terminal.portUno)) {
        setState(
          () {
            terminal.isPortSelected = true;
          },
        );
      } else {
        setState(
          () {
            terminal.isPortSelected = false;
            terminal.isSelected = false;
          },
        );
      }
    }

    return Column(
      children: filterData.terminalList!
          .where((terminal) => filterData.portList!.any((port) =>
              port.isSelected &&
              port.portUno == terminal.portUno &&
              filterData.countryList!.any((con) =>
                  con.isSelected &&
                  con.countryUno == port.countryUno &&
                  filterData.regionList!.any((reg) =>
                      reg.isSelected && reg.regionUno == con.regionUno))))
          .map((ter) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(
                Colors.black,
              ),
              value: ter.isSelected,
              onChanged: (bool? val) {
                setState(() {
                  ter.isSelected = val!;
                });
              },
            ),
            Text(ter.terminalCode!),
          ],
        );
      }).toList(),
    );
  }

  Column buildOperatorFilter(StateSetter setState) {
    if (filterData.operatorList == null) {
      return Column();
    }
    return Column(
      children: filterData.operatorList!.map((op) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(
                Colors.black,
              ),
              value: op.isSelected,
              onChanged: (bool? val) {
                setState(() {
                  op.isSelected = val!;
                });
              },
            ),
            Text(op.operatorCode!),
          ],
        );
      }).toList(),
    );
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
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.5),
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary.withOpacity(0.0),
                ],
                stops: const [
                  0.2,
                  0.4,
                  0.7,
                  0.9,
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isFilterDatafetched() && isWidgetsDataFetched())
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                refreshData();
              },
            ),
        ],
      ),
      drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
      body: Stack(children: [
        Positioned(
          right: -10,
          top: 150,
          child: RotatedBox(
            quarterTurns: -1,
            child: Image.asset(
              "assets/images/earth icon.png",
              height: 300,
              opacity: const AlwaysStoppedAnimation(.5),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () async {
            refreshData();
          },
          child: Visibility(
            visible: isLoading == false,
            replacement: Helpers.loadingIndicator(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
                vertical: mediaQuery.size.height * 0.01,
              ),
              child: isFilterDatafetched() && isWidgetsDataFetched()
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedRegions.toString()}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontFamily: 'Pilat Heavy',
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity(horizontal: -4),
                                onPressed: () => dialog(),
                                icon: const Icon(Icons.manage_search))
                          ],
                        ),
                        buildGredientLine(
                          mediaQuery,
                          theme,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              MapChart(filterData.countryList),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartView(
                                widgetsData.bidWidgetDetails!,
                                "GDP",
                                "GDP",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartView(
                                widgetsData.bidWidgetDetails!,
                                "GDPGR",
                                "GDPGR",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartView(
                                widgetsData.bidWidgetDetails!,
                                "POP",
                                "POPULATION",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartView(
                                widgetsData.bidWidgetDetails!,
                                "VOL",
                                "VOLUME",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartWithoutFilterView(
                                widgetsData.bidWidgetDetails!,
                                filterData,
                                "CAPACITY",
                                "CAPACITY",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              BIDChartWithoutFilterView(
                                widgetsData.bidWidgetDetails!,
                                filterData,
                                "DEVELOPMENT",
                                "DEVELOPMENT",
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "NATURE OF INVOLVEMENT",
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
                                height: 350,
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: NatureOfInvolvement(
                                        widgetsData.bidWidgetDetails!),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text("An Error Occured While Rendering Data")),
            ),
          ),
        ),
      ]),
    );
  }
}
