import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/dashboard_provider.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeController extends GetxController with StateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  late WidgetDataResponse widgetsData = WidgetDataResponse();
  late FilterDataResponse filterData = FilterDataResponse();
  StringBuffer selectedRegions = StringBuffer();
  late List<Country> visibleCountryList = <Country>[];
  late List<Port> visiblePortList = <Port>[];
  late List<Terminal> visibleTerminalList = <Terminal>[];
  late List<Operator> visibleOperatorList = <Operator>[];
  late int renderType = 0;
  bool isInitLoading = false;
  bool isRegionChanged = false;
  bool isDataUpdated = false;
  bool isRegionFilterVisible = false;
  bool isCountryFilterVisible = false;
  bool isPortFilterVisible = false;
  bool isTerminalFilterVisible = false;
  bool isOperatorFilterVisible = false;
  bool isFilterOpened = false;
  bool isAllRegionsSelected = false;
  bool isAllCountriesSelected = true;
  bool isAllPortsSelected = true;
  bool isAllTerminalsSelected = true;
  bool isAllOperatorsSelected = true;
  bool isMapVisible = false;
  bool isChartsVisible = true;

  final itemController = ItemScrollController();
  @override
  void onReady() {
    super.onReady();
    initData();
  }

  void showMap() async {
    isMapVisible = true;
    isChartsVisible = false;
    update();
  }

  void showCharts(bool showMapAnswer) async {
    isMapVisible = showMapAnswer;
    isChartsVisible = true;
    update();
  }

  void autoScroll() {
    scrollController.animateTo(
      MediaQuery.of(Get.context!).size.height * 0.5,
      duration: Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  void checkSelectAll(String filterType) {
    switch (filterType) {
      case "REGION":
        if (filterData.regionList!.every((reg) => reg.isFitlerSelected)) {
          isAllRegionsSelected = true;
        } else {
          isAllRegionsSelected = false;
        }

        break;
      case "COUNTRY":
        if (visibleCountryList.every((con) => con.isFitlerSelected)) {
          isAllCountriesSelected = true;
        } else {
          isAllCountriesSelected = false;
        }

        break;
      case "PORT":
        if (visiblePortList.every((por) => por.isFitlerSelected)) {
          isAllPortsSelected = true;
        } else {
          isAllPortsSelected = false;
        }
        break;
      case "TERMINAL":
        if (visibleTerminalList.every((ter) => ter.isFitlerSelected)) {
          isAllTerminalsSelected = true;
        } else {
          isAllTerminalsSelected = false;
        }

        break;
      case "OPERATOR":
        if (visibleOperatorList.every((op) => op.isFitlerSelected)) {
          isAllOperatorsSelected = true;
        } else {
          isAllOperatorsSelected = false;
        }
        break;
      default:
    }
  }

  void onSelectAll(String filterType, bool isSelectAll) {
    switch (filterType) {
      case "REGION":
        if (isSelectAll) {
          filterData.regionList?.forEach((region) {
            region.isFitlerSelected = true;
          });
        } else {
          filterData.regionList?.forEach((region) {
            region.isFitlerSelected = false;
          });
        }
        updateCountryFilter();
        updatePortFilter();
        updateTerminalAndOperatorFilters();

        break;
      case "COUNTRY":
        if (isSelectAll) {
          visibleCountryList.forEach((con) {
            con.isFitlerSelected = true;
          });
        } else {
          visibleCountryList.forEach((con) {
            con.isFitlerSelected = false;
          });
        }
        updatePortFilter();
        updateTerminalAndOperatorFilters();
        break;
      case "PORT":
        if (isSelectAll) {
          visiblePortList.forEach((port) {
            port.isFitlerSelected = true;
          });
        } else {
          visiblePortList.forEach((port) {
            port.isFitlerSelected = false;
          });
        }
        updateTerminalAndOperatorFilters();
        break;
      case "TERMINAL":
        if (isSelectAll) {
          visibleTerminalList.forEach((terminal) {
            terminal.isFitlerSelected = true;
          });
        } else {
          visibleTerminalList.forEach((terminal) {
            terminal.isFitlerSelected = false;
          });
        }

        break;
      case "OPERATOR":
        if (isSelectAll) {
          visibleOperatorList.forEach((operator) {
            operator.isFitlerSelected = true;
          });
        } else {
          visibleOperatorList.forEach((operator) {
            operator.isFitlerSelected = false;
          });
        }
        break;
      default:
    }
  }

  void getSelectedRegion() {
    selectedRegions.clear();
    for (var region in filterData.regionList!.where((reg) => reg.isSelected)) {
      if (region ==
          filterData.regionList!.where((reg) => reg.isSelected).toList().last) {
        selectedRegions.write('${region.regionCode} ');
      } else {
        selectedRegions.write('${region.regionCode}, ');
      }
      update();
    }
  }

  void resetFilter() {
    isAllRegionsSelected = false;
    isAllCountriesSelected = false;
    isAllPortsSelected = false;
    isAllTerminalsSelected = false;
    isAllOperatorsSelected = false;

    filterData.regionList?.forEach((region) {
      region.isSelected = true;
      region.isFitlerSelected = false;
    });
    filterData.countryList?.forEach((country) {
      country.isSelected = true;
      country.isFitlerSelected = false;
    });
    filterData.portList?.forEach((port) {
      port.isSelected = true;
      port.isFitlerSelected = false;
    });
    filterData.terminalList?.forEach((terminal) {
      terminal.isSelected = true;
      terminal.isFitlerSelected = false;
    });
    filterData.operatorList?.forEach((operator) {
      operator.isSelected = true;
      operator.isFitlerSelected = false;
    });
    update();
  }

  void updateCountryFilter() {
    for (var country in filterData.countryList!) {
      if (filterData.regionList!.any((reg) =>
          reg.isFitlerSelected && reg.regionUno == country.regionUno)) {
        country.isRegionSelected = true;
        country.isFitlerSelected = true;
        country.isSelected = true;
      } else {
        country.isRegionSelected = false;
        country.isFitlerSelected = false;
        country.isSelected = false;
      }
    }
  }

  void updatePortFilter() {
    for (var port in filterData.portList!) {
      if (filterData.countryList!.any(
          (con) => con.isFitlerSelected && con.countryUno == port.countryUno)) {
        port.isCountrySelected = true;
        port.isFitlerSelected = true;
        port.isSelected = true;
      } else {
        port.isCountrySelected = false;
        port.isFitlerSelected = false;
        port.isSelected = false;
      }
    }
  }

  void updateTerminalAndOperatorFilters() {
    for (var terminal in filterData.terminalList!) {
      if (filterData.portList!.any((port) =>
          port.isFitlerSelected && port.portUno == terminal.portUno)) {
        terminal.isPortSelected = true;
        terminal.isFitlerSelected = true;
        terminal.isSelected = true;
      } else {
        terminal.isPortSelected = false;
        terminal.isFitlerSelected = false;
        terminal.isSelected = false;
      }
    }

    for (var operator in filterData.operatorList!) {
      if (filterData.portList!.any((port) =>
          port.isFitlerSelected && port.portUno == operator.portUno)) {
        operator.isPortSelected = true;
        operator.isFitlerSelected = true;
        operator.isSelected = true;
      } else {
        operator.isPortSelected = false;
        operator.isFitlerSelected = false;
        operator.isSelected = false;
      }
      update();
    }
  }

  void updateFilterOutput() {
    filterData.regionList?.forEach((region) {
      if (region.isFitlerSelected) {
        region.isSelected = true;
      } else {
        region.isSelected = false;
      }
    });

    filterData.countryList?.forEach((country) {
      if (country.isFitlerSelected) {
        country.isSelected = true;
      } else {
        country.isSelected = false;
      }
    });

    filterData.portList?.forEach((port) {
      if (port.isFitlerSelected) {
        port.isSelected = true;
      } else {
        port.isSelected = false;
      }
    });

    filterData.terminalList?.forEach((terminal) {
      if (terminal.isFitlerSelected) {
        terminal.isSelected = true;
      } else {
        terminal.isSelected = false;
      }
    });

    filterData.operatorList?.forEach((operator) {
      if (operator.isFitlerSelected) {
        operator.isSelected = true;
      } else {
        operator.isSelected = false;
      }
    });
    update();
  }

  void initData() async {
    change(null, status: RxStatus.loading());
    isInitLoading = true;
    update();
    try {
      if (await Helpers.checkConnectivity()) {
        if (isDataUpdated == false) {
          await getFilterData();
        }
        getSelectedRegion();
        await getWidgetData(prepareWidgetDataBody(true));
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      isInitLoading = false;
      update();
      change(null, status: RxStatus.success());
    } catch (error) {
      isInitLoading = false;
      change(null, status: RxStatus.error("Internal Error Occured"));
    }
  }

  void refreshData() async {
    change(null, status: RxStatus.loading());
    renderType = 0;
    isChartsVisible = true;
    update();

    try {
      if (await Helpers.checkConnectivity()) {
        if (filterData.regionList!.any((reg) => reg.isSelected) &&
            filterData.countryList!.any((cont) => cont.isSelected)) {
          await getWidgetData(prepareWidgetDataBody(false));
          getSelectedRegion();
        } else {
          await getWidgetData(prepareWidgetDataBody(true));
          getSelectedRegion();
        }
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }

      update();
      change(null, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error("Internal Error Occured"));
    }
  }

  void filterFromMap(
      WidgetDataRequest widgetDatarequest, int sentRenderType) async {
    change(null, status: RxStatus.loading());

    renderType = sentRenderType;
    update();

    try {
      if (await Helpers.checkConnectivity()) {
        await getWidgetData(widgetDatarequest);
        getSelectedRegion();
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }

      update();
      change(null, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error("Internal Error Occured"));
    }
  }

  bool isFilterDataFetched() {
    if (filterData.statusCode == 500) {
      return false;
    }
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
    if (widgetsData.statusCode == 500) {
      return false;
    }
    if (widgetsData.bidWidgetDetails != null) {
      return true;
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

    filterData =
        await Get.find<DashboardProvider>().getBIDFilterData(filterRequestBody);

    if (filterData.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (filterData.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  Future<void> getWidgetData(WidgetDataRequest widgetRequestBody) async {
    widgetsData = await Get.find<DashboardProvider>()
        .getBIDashboardWidgetData(widgetRequestBody);

    if (widgetsData.statusCode == 401) {
      await Get.toNamed(Routes.LOGIN);
    } else if (widgetsData.statusCode == 500) {
      await Helpers.dialog(
          Icons.error, Colors.red, 'Intenral Server Error Occured');
    }
  }

  WidgetDataRequest prepareWidgetDataBody(bool isInit) {
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

    if (isInit) {
      for (var region in filterData.regionList!) {
        if (filterData.regionList?.last == region) {
          regionUnoBody.write(region.regionUno);
        } else {
          regionUnoBody.write('${region.regionUno},');
        }
      }

      for (var country in filterData.countryList!) {
        if (filterData.countryList?.last == country) {
          countryUnoBody.write(country.countryUno);
        } else {
          countryUnoBody.write('${country.countryUno},');
        }
      }

      for (var port in filterData.portList!) {
        if (filterData.portList?.last == port) {
          portUnoBody.write(port.portUno);
        } else {
          portUnoBody.write('${port.portUno},');
        }
      }

      for (var terminal in filterData.terminalList!) {
        if (filterData.terminalList?.last == terminal) {
          terminalUnoBody.write(terminal.terminalUno);
        } else {
          terminalUnoBody.write('${terminal.terminalUno},');
        }
      }
      for (var operator in filterData.operatorList!) {
        if (filterData.operatorList?.last == operator) {
          operatorUnoBody.write(operator.operatorUno);
        } else {
          operatorUnoBody.write('${operator.operatorUno},');
        }
      }
    } else {
      for (var region
          in filterData.regionList!.where((reg) => reg.isSelected)) {
        if (filterData.regionList?.last == region) {
          regionUnoBody.write(region.regionUno);
        } else {
          regionUnoBody.write('${region.regionUno},');
        }
      }

      for (var country
          in filterData.countryList!.where((con) => con.isSelected)) {
        if (filterData.countryList?.last == country) {
          countryUnoBody.write(country.countryUno);
        } else {
          countryUnoBody.write('${country.countryUno},');
        }
      }

      for (var port in filterData.portList!.where((por) => por.isSelected)) {
        if (filterData.portList?.last == port) {
          portUnoBody.write(port.portUno);
        } else {
          portUnoBody.write('${port.portUno},');
        }
      }

      for (var terminal
          in filterData.terminalList!.where((ter) => ter.isSelected)) {
        if (filterData.terminalList?.last == terminal) {
          terminalUnoBody.write(terminal.terminalUno);
        } else {
          terminalUnoBody.write('${terminal.terminalUno},');
        }
      }
      for (var operator in filterData.operatorList!
          .where((op) => op.isSelected)
          .distinct(((opr) => opr.operatorUno))
          .toList()) {
        if (filterData.operatorList?.last == operator) {
          operatorUnoBody.write(operator.operatorUno);
        } else {
          operatorUnoBody.write('${operator.operatorUno},');
        }
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
        context: Get.context!,
        builder: (ctx) => GetBuilder<HomeController>(
            init: HomeController(),
            builder: (_) => SimpleDialog(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(Get.context!).size.width * 0.04,
                        vertical: MediaQuery.of(Get.context!).size.width * 0.02,
                      ),
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
                                  fontSize:
                                      MediaQuery.of(Get.context!).size.width *
                                          0.04,
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              ListTile(
                                onTap: () {
                                  isRegionFilterVisible =
                                      !isRegionFilterVisible;
                                  isCountryFilterVisible = false;
                                  isPortFilterVisible = false;
                                  isTerminalFilterVisible = false;
                                  isOperatorFilterVisible = false;
                                  update();
                                },
                                visualDensity: VisualDensity(vertical: -4),
                                leading: Text(
                                  "REGION",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.04,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                              if (isRegionFilterVisible)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: Checkbox(
                                        checkColor: Colors.black,
                                        fillColor: MaterialStateProperty.all(
                                          Colors.black,
                                        ),
                                        value: isAllRegionsSelected,
                                        onChanged: (bool? val) {
                                          isAllRegionsSelected = val!;
                                          onSelectAll("REGION", val);
                                          update();
                                        },
                                      ),
                                      title: Text(
                                        "Select All",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    buildRegionFilter()
                                  ],
                                ),
                              ListTile(
                                onTap: () {
                                  isCountryFilterVisible =
                                      !isCountryFilterVisible;
                                  isRegionFilterVisible = false;
                                  isPortFilterVisible = false;
                                  isTerminalFilterVisible = false;
                                  isOperatorFilterVisible = false;
                                  isFilterOpened = true;
                                  checkSelectAll("COUNTRIES");
                                  update();
                                },
                                visualDensity: VisualDensity(vertical: -4),
                                leading: Text(
                                  "COUNRTY",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.04,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                              if (isCountryFilterVisible)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: Checkbox(
                                        checkColor: Colors.black,
                                        fillColor: MaterialStateProperty.all(
                                          Colors.black,
                                        ),
                                        value: isAllCountriesSelected,
                                        onChanged: (bool? val) {
                                          isAllCountriesSelected = val!;
                                          onSelectAll("COUNTRY", val);
                                          update();
                                        },
                                      ),
                                      title: Text(
                                        "Select All",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    buildCountryFilter(),
                                  ],
                                ),
                              ListTile(
                                onTap: () {
                                  isPortFilterVisible = !isPortFilterVisible;
                                  isCountryFilterVisible = false;
                                  isRegionFilterVisible = false;
                                  isTerminalFilterVisible = false;
                                  isOperatorFilterVisible = false;
                                  isFilterOpened = true;
                                  update();
                                },
                                visualDensity: VisualDensity(vertical: -4),
                                leading: Text(
                                  "PORT",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.04,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                              if (isPortFilterVisible)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: Checkbox(
                                        checkColor: Colors.black,
                                        fillColor: MaterialStateProperty.all(
                                          Colors.black,
                                        ),
                                        value: isAllPortsSelected,
                                        onChanged: (bool? val) {
                                          isAllPortsSelected = val!;
                                          onSelectAll("PORT", val);
                                          update();
                                        },
                                      ),
                                      title: Text(
                                        "Select All",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    buildPortFilter(),
                                  ],
                                ),
                              ListTile(
                                onTap: () {
                                  isTerminalFilterVisible =
                                      !isTerminalFilterVisible;
                                  isCountryFilterVisible = false;
                                  isPortFilterVisible = false;
                                  isRegionFilterVisible = false;
                                  isOperatorFilterVisible = false;
                                  isFilterOpened = true;
                                  update();
                                },
                                visualDensity: VisualDensity(vertical: -4),
                                leading: Text(
                                  "TERMINAL",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.04,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                              if (isTerminalFilterVisible)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: Checkbox(
                                        checkColor: Colors.black,
                                        fillColor: MaterialStateProperty.all(
                                          Colors.black,
                                        ),
                                        value: isAllTerminalsSelected,
                                        onChanged: (bool? val) {
                                          isAllTerminalsSelected = val!;
                                          onSelectAll("TERMINAL", val);
                                        },
                                      ),
                                      title: Text(
                                        "Select All",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    buildTerminalFilter(),
                                  ],
                                ),
                              ListTile(
                                onTap: () {
                                  isOperatorFilterVisible =
                                      !isOperatorFilterVisible;
                                  isCountryFilterVisible = false;
                                  isPortFilterVisible = false;
                                  isTerminalFilterVisible = false;
                                  isRegionFilterVisible = false;
                                  isFilterOpened = true;
                                  update();
                                },
                                visualDensity: VisualDensity(
                                  vertical: -4,
                                ),
                                leading: Text(
                                  "OPERATOR",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(Get.context!).size.width *
                                            0.04,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                              if (isOperatorFilterVisible)
                                Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0,
                                      leading: Checkbox(
                                        checkColor: Colors.black,
                                        fillColor: MaterialStateProperty.all(
                                          Colors.black,
                                        ),
                                        value: isAllOperatorsSelected,
                                        onChanged: (bool? val) {
                                          isAllOperatorsSelected = val!;
                                          onSelectAll("OPERATOR", val);
                                          update();
                                        },
                                      ),
                                      title: Text(
                                        "Select All",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(Get.context!)
                                                  .size
                                                  .width *
                                              0.035,
                                        ),
                                      ),
                                    ),
                                    buildOperatorFilter(),
                                  ],
                                ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      resetFilter();
                                      update();
                                    },
                                    child: Text(
                                      "Reset Filter",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Pilat Demi',
                                        fontSize: MediaQuery.of(Get.context!)
                                                .size
                                                .width *
                                            0.04,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (filterData.regionList!.any((reg) =>
                                                  reg.isFitlerSelected) ==
                                              false ||
                                          filterData.countryList!.any((con) =>
                                                  con.isFitlerSelected) ==
                                              false) {
                                        resetFilter();
                                      } else {
                                        updateFilterOutput();
                                      }

                                      refreshData();
                                      update();
                                      Get.back();
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Pilat Demi',
                                        fontSize: MediaQuery.of(Get.context!)
                                                .size
                                                .width *
                                            0.04,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ],
                )));
  }

  Column buildRegionFilter() {
    if (filterData.regionList == null) {
      return Column(
        children: [],
      );
    }
    if (filterData.regionList!.isEmpty) {
      return Column(
        children: [],
      );
    }

    checkSelectAll("REGION");

    return Column(
      children: filterData.regionList!.map((reg) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          leading: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(
              Colors.black,
            ),
            value: reg.isFitlerSelected,
            onChanged: (bool? val) {
              reg.isFitlerSelected = val!;
              reg.isSelected = val;
              checkSelectAll("REGION");
              updateCountryFilter();
              updatePortFilter();
              updateTerminalAndOperatorFilters();
              update();
            },
          ),
          title: Text(
            reg.regionName!,
            style: TextStyle(
              fontSize: MediaQuery.of(Get.context!).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildCountryFilter() {
    if (filterData.countryList == null || filterData.regionList == null) {
      return Column();
    }
    if (filterData.countryList!.isEmpty || filterData.regionList!.isEmpty) {
      return Column();
    }

    visibleCountryList = filterData.countryList!
        .where((country) => filterData.regionList!.any((reg) =>
            reg.isFitlerSelected && reg.regionUno == country.regionUno))
        .toList();

    checkSelectAll("COUNTRY");

    return Column(
      children: visibleCountryList.map((con) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          leading: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(
              Colors.black,
            ),
            value: con.isFitlerSelected,
            onChanged: (bool? val) {
              con.isFitlerSelected = val!;
              con.isSelected = val;
              checkSelectAll("COUNTRY");
              updatePortFilter();
              updateTerminalAndOperatorFilters();
              update();
            },
          ),
          title: Text(
            con.countryName!,
            style: TextStyle(
              fontSize: MediaQuery.of(Get.context!).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildPortFilter() {
    if (filterData.countryList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.countryList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }

    visiblePortList = filterData.portList!
        .where((port) => filterData.countryList!.any((con) =>
            con.isFitlerSelected &&
            con.countryUno == port.countryUno &&
            filterData.regionList!.any((reg) =>
                reg.isFitlerSelected && reg.regionUno == con.regionUno)))
        .toList();
    checkSelectAll("PORT");

    return Column(
      children: visiblePortList.map((por) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          leading: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(
              Colors.black,
            ),
            value: por.isFitlerSelected,
            onChanged: (bool? val) {
              por.isFitlerSelected = val!;
              por.isSelected = val;
              checkSelectAll("PORT");
              updateTerminalAndOperatorFilters();
              update();
            },
          ),
          title: Text(
            por.portName!,
            style: TextStyle(
              fontSize: MediaQuery.of(Get.context!).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildTerminalFilter() {
    if (filterData.terminalList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.terminalList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }

    visibleTerminalList = filterData.terminalList!
        .where((terminal) => filterData.portList!.any((port) =>
            port.isFitlerSelected &&
            port.portUno == terminal.portUno &&
            filterData.countryList!.any((con) =>
                con.isFitlerSelected &&
                con.countryUno == port.countryUno &&
                filterData.regionList!.any((reg) =>
                    reg.isFitlerSelected && reg.regionUno == con.regionUno))))
        .toList();
    checkSelectAll("TERMINAL");

    return Column(
      children: visibleTerminalList.map((ter) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          leading: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(
              Colors.black,
            ),
            value: ter.isFitlerSelected,
            onChanged: (bool? val) {
              ter.isFitlerSelected = val!;
              ter.isSelected = val;
              checkSelectAll("TERMINAL");
              update();
            },
          ),
          title: Text(
            ter.terminalName!,
            style: TextStyle(
              fontSize: MediaQuery.of(Get.context!).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildOperatorFilter() {
    if (filterData.operatorList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.operatorList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }

    visibleOperatorList = filterData.operatorList!
        .where((operator) => filterData.portList!.any((port) =>
            port.isFitlerSelected &&
            port.portUno == operator.portUno &&
            filterData.countryList!.any((con) =>
                con.isFitlerSelected &&
                con.countryUno == port.countryUno &&
                filterData.regionList!.any((reg) =>
                    reg.isFitlerSelected && reg.regionUno == con.regionUno))))
        .toList();
    checkSelectAll("OPERATOR");

    return Column(
      children: filterData.operatorList!
          .where((operator) => filterData.portList!.any((port) =>
              port.isFitlerSelected &&
              port.portUno == operator.portUno &&
              filterData.countryList!.any((con) =>
                  con.isFitlerSelected &&
                  con.countryUno == port.countryUno &&
                  filterData.regionList!.any((reg) =>
                      reg.isFitlerSelected && reg.regionUno == con.regionUno))))
          .distinct(((wid) => wid.operatorUno))
          .toList()
          .map((op) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          leading: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(
              Colors.black,
            ),
            value: op.isFitlerSelected,
            onChanged: (bool? val) {
              op.isFitlerSelected = val!;
              op.isSelected = val;
              checkSelectAll("OPERATOR");
              update();
            },
          ),
          title: Text(
            op.operatorName!,
            style: TextStyle(
              fontSize: MediaQuery.of(Get.context!).size.width * 0.04,
            ),
          ),
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
}
