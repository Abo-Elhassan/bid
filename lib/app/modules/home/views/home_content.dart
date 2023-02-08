import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';

import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';

import 'package:bid_app/app/data/models/responses/widget_data_response.dart';

import 'package:bid_app/app/data/providers/dashboard_provider.dart';
import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
import 'package:bid_app/shared/charts/bid_chart_view.dart';

import 'package:bid_app/shared/charts/noi.dart';
import 'package:bid_app/shared/charts/noi_view.dart';
import 'package:bid_app/shared/side_menu.dart';

import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/shared/charts/map_chart.dart';
import 'package:darq/darq.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class HomeContent extends StatefulWidget {
  // final Function fetchData;
  // const HomeContent({required this.fetchData});
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  ScrollController _scrollController = ScrollController();
  late WidgetDataResponse widgetsData = WidgetDataResponse();
  late FilterDataResponse filterData = FilterDataResponse();
  StringBuffer selectedRegions = StringBuffer();

  late List<Country> visibleCountryList = <Country>[];
  late List<Port> visiblePortList = <Port>[];
  late List<Terminal> visibleTerminalList = <Terminal>[];
  late List<Operator> visibleOperatorList = <Operator>[];
  late int renderType = 0;
  bool isLoading = false;
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

  @override
  void initState() {
    super.initState();
    initData();
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
        setState(() {
          selectedRegions.write('${region.regionCode} ');
        });
      } else {
        setState(() {
          selectedRegions.write('${region.regionCode}, ');
        });
      }
    }
  }

  void resetFilter() {
    setState(() {
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
    });
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
        setState(
          () {
            operator.isPortSelected = true;
            operator.isFitlerSelected = true;
            operator.isSelected = true;
          },
        );
      } else {
        setState(
          () {
            operator.isPortSelected = false;
            operator.isFitlerSelected = false;
            operator.isSelected = false;
          },
        );
      }
    }
  }

  void updateFilterOutput() {
    setState(() {
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
    });
  }

  void initData() async {
    setState(() {
      isLoading = true;
    });
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
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  void refreshData() async {
    setState(() {
      isLoading = true;
      renderType = 0;
    });

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
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }

  void filterFromMap(
      WidgetDataRequest widgetDatarequest, int sentRenderType) async {
    setState(() {
      isLoading = true;
      renderType = sentRenderType;
    });

    try {
      if (await Helpers.checkConnectivity()) {
        await getWidgetData(widgetDatarequest);
        getSelectedRegion();
      } else {
        await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
            'Please check Your Netowork Connection');
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
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
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, setState) {
            return SimpleDialog(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(Get.context!).size.width * 0.04,
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
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isRegionFilterVisible = !isRegionFilterVisible;
                                isCountryFilterVisible = false;
                                isPortFilterVisible = false;
                                isTerminalFilterVisible = false;
                                isOperatorFilterVisible = false;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "REGION",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                      setState(() {
                                        isAllRegionsSelected = val!;
                                        onSelectAll("REGION", val);
                                      });
                                    },
                                  ),
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                buildRegionFilter(setState)
                              ],
                            ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isCountryFilterVisible =
                                    !isCountryFilterVisible;
                                isRegionFilterVisible = false;
                                isPortFilterVisible = false;
                                isTerminalFilterVisible = false;
                                isOperatorFilterVisible = false;
                                isFilterOpened = true;
                                checkSelectAll("COUNTRIES");
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "COUNRTY",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                      setState(() {
                                        isAllCountriesSelected = val!;
                                        onSelectAll("COUNTRY", val);
                                      });
                                    },
                                  ),
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                buildCountryFilter(setState),
                              ],
                            ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isPortFilterVisible = !isPortFilterVisible;
                                isCountryFilterVisible = false;
                                isRegionFilterVisible = false;
                                isTerminalFilterVisible = false;
                                isOperatorFilterVisible = false;
                                isFilterOpened = true;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "PORT",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                      setState(() {
                                        isAllPortsSelected = val!;
                                        onSelectAll("PORT", val);
                                      });
                                    },
                                  ),
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                buildPortFilter(setState),
                              ],
                            ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isTerminalFilterVisible =
                                    !isTerminalFilterVisible;
                                isCountryFilterVisible = false;
                                isPortFilterVisible = false;
                                isRegionFilterVisible = false;
                                isOperatorFilterVisible = false;
                                isFilterOpened = true;
                              });
                            },
                            visualDensity: VisualDensity(vertical: -4),
                            leading: Text(
                              "TERMINAL",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Pilat Demi',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                      setState(() {
                                        isAllTerminalsSelected = val!;
                                        onSelectAll("TERMINAL", val);
                                      });
                                    },
                                  ),
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                buildTerminalFilter(setState),
                              ],
                            ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                isOperatorFilterVisible =
                                    !isOperatorFilterVisible;
                                isCountryFilterVisible = false;
                                isPortFilterVisible = false;
                                isTerminalFilterVisible = false;
                                isRegionFilterVisible = false;
                                isFilterOpened = true;
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
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
                                      setState(() {
                                        isAllOperatorsSelected = val!;
                                        onSelectAll("OPERATOR", val);
                                      });
                                    },
                                  ),
                                  title: Text(
                                    "Select All",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                buildOperatorFilter(setState),
                              ],
                            ),
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
                                      resetFilter();
                                    },
                                  );
                                },
                                child: Text(
                                  "Reset Filter",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
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
                                  });
                                  Get.back();
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pilat Demi',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
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
            );
          });
        });
  }

  Column buildRegionFilter(StateSetter setState) {
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

    setState(
      () {
        checkSelectAll("REGION");
      },
    );

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
              setState(() {
                reg.isFitlerSelected = val!;
                reg.isSelected = val;
                checkSelectAll("REGION");
                updateCountryFilter();
                updatePortFilter();
                updateTerminalAndOperatorFilters();
              });
            },
          ),
          title: Text(
            reg.regionName!,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildCountryFilter(StateSetter setState) {
    if (filterData.countryList == null || filterData.regionList == null) {
      return Column();
    }
    if (filterData.countryList!.isEmpty || filterData.regionList!.isEmpty) {
      return Column();
    }
    setState(
      () {
        visibleCountryList = filterData.countryList!
            .where((country) => filterData.regionList!.any((reg) =>
                reg.isFitlerSelected && reg.regionUno == country.regionUno))
            .toList();

        checkSelectAll("COUNTRY");
      },
    );

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
              setState(() {
                con.isFitlerSelected = val!;
                con.isSelected = val;
                checkSelectAll("COUNTRY");
                updatePortFilter();
                updateTerminalAndOperatorFilters();
              });
            },
          ),
          title: Text(
            con.countryName!,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildPortFilter(StateSetter setState) {
    if (filterData.countryList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.countryList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }

    setState(
      () {
        visiblePortList = filterData.portList!
            .where((port) => filterData.countryList!.any((con) =>
                con.isFitlerSelected &&
                con.countryUno == port.countryUno &&
                filterData.regionList!.any((reg) =>
                    reg.isFitlerSelected && reg.regionUno == con.regionUno)))
            .toList();
        checkSelectAll("PORT");
      },
    );
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
              setState(() {
                por.isFitlerSelected = val!;
                por.isSelected = val;
                checkSelectAll("PORT");
                updateTerminalAndOperatorFilters();
              });
            },
          ),
          title: Text(
            por.portName!,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildTerminalFilter(StateSetter setState) {
    if (filterData.terminalList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.terminalList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }
    setState(
      () {
        visibleTerminalList = filterData.terminalList!
            .where((terminal) => filterData.portList!.any((port) =>
                port.isFitlerSelected &&
                port.portUno == terminal.portUno &&
                filterData.countryList!.any((con) =>
                    con.isFitlerSelected &&
                    con.countryUno == port.countryUno &&
                    filterData.regionList!.any((reg) =>
                        reg.isFitlerSelected &&
                        reg.regionUno == con.regionUno))))
            .toList();
        checkSelectAll("TERMINAL");
      },
    );

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
              setState(() {
                ter.isFitlerSelected = val!;
                ter.isSelected = val;
                checkSelectAll("TERMINAL");
              });
            },
          ),
          title: Text(
            ter.terminalName!,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        );
      }).toList(),
    );
  }

  Column buildOperatorFilter(StateSetter setState) {
    if (filterData.operatorList == null || filterData.portList == null) {
      return Column();
    }
    if (filterData.operatorList!.isEmpty || filterData.portList!.isEmpty) {
      return Column();
    }
    setState(
      () {
        visibleOperatorList = filterData.operatorList!
            .where((operator) => filterData.portList!.any((port) =>
                port.isFitlerSelected &&
                port.portUno == operator.portUno &&
                filterData.countryList!.any((con) =>
                    con.isFitlerSelected &&
                    con.countryUno == port.countryUno &&
                    filterData.regionList!.any((reg) =>
                        reg.isFitlerSelected &&
                        reg.regionUno == con.regionUno))))
            .toList();
        checkSelectAll("OPERATOR");
      },
    );

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
              setState(() {
                op.isFitlerSelected = val!;
                op.isSelected = val;
                checkSelectAll("OPERATOR");
              });
            },
          ),
          title: Text(
            op.operatorName!,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            },
            child: Icon(Icons.arrow_upward)),
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
                refreshData();
              },
            ),
          ],
        ),
        drawer: Helpers.getCurrentUser().roleType == 1
            ? SideMenu(Helpers.getCurrentUser().username.toString())
            : null,
        body: Stack(children: [
          Positioned(
            right: -10,
            top: 100,
            child: RotatedBox(
              quarterTurns: -1,
              child: Image.asset(
                Assets.kEarthLines,
                height: MediaQuery.of(context).size.height * 0.45,
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.05,
                  vertical: mediaQuery.size.height * 0.01,
                ),
                child: isFilterDataFetched() && isWidgetsDataFetched()
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(horizontal: -4),
                                  onPressed: () => dialog(),
                                  icon: Icon(
                                    Icons.manage_search,
                                    size: MediaQuery.of(context).size.width *
                                        0.07,
                                  ))
                            ],
                          ),
                          buildGredientLine(
                            mediaQuery,
                            theme,
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              controller: _scrollController,
                              children: [
                                MapChart(filterFromMap, filterData.countryList!,
                                    filterData),
                                SizedBox(
                                  height: 50,
                                ),
                                Visibility(
                                  visible: isLoading == false,
                                  replacement: Helpers.loadingIndicator(),
                                  child: Column(
                                    children: [
                                      if (renderType == 0 || renderType == 1)
                                        FilteredBIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          "GDP",
                                          "GDP",
                                        ),
                                      if (renderType == 0 || renderType == 1)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 0 || renderType == 1)
                                        FilteredBIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          "GDPGR",
                                          "GDPGR",
                                        ),
                                      if (renderType == 0 || renderType == 1)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 0 || renderType == 1)
                                        FilteredBIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          "POP",
                                          "POPULATION",
                                        ),
                                      if (renderType == 0 || renderType == 1)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        FilteredBIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          "VOL",
                                          "VOLUME",
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        BIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          filterData,
                                          "CAPACITY",
                                          "CAPACITY",
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        BIDChartView(
                                          widgetsData.bidWidgetDetails!,
                                          filterData,
                                          "DEVELOPMENT",
                                          "DEVELOPMENT",
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        SizedBox(
                                          height: 50,
                                        ),
                                      if (renderType == 2 || renderType == 0)
                                        NatureOfInvlovementView(
                                          widgetsData.bidWidgetDetails!,
                                        ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(child: Text("")),
              ))
        ]));
  }
}
