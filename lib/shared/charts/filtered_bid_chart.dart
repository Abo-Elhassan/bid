import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilteredBIDChart extends StatefulWidget {
  final String chartType;
  final String chartTitle;
  final List<BidWidgetDetails> bidWidgetDetails;
  final List<String> yearList;
  final double minVal;
  final double maxVal;
  final double? interval;

  FilteredBIDChart({
    required this.bidWidgetDetails,
    required this.chartType,
    required this.chartTitle,
    required this.yearList,
    required this.minVal,
    required this.maxVal,
    required this.interval,
  });

  @override
  FilteredBIDChartState createState() => FilteredBIDChartState();
}

class FilteredBIDChartState extends State<FilteredBIDChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = <BidWidgetDetails>[];
  late List<BidWidgetDetails> showedWidgets = widgetDetails;
  late String showedYear = widget.yearList[0];
  late List<ChartData> data = <ChartData>[];
  late BidWidgetDetails maxItem = BidWidgetDetails();
  late BidWidgetDetails minItem = BidWidgetDetails();
  late double minVal = 0;
  late double maxVal = 0;
  late double? interval;
  late int maxXValue = 0;
  late String xValue = "";

  void setChartXvalue() {
    data = <ChartData>[];
    if (showedWidgets.isNotEmpty) {
      switch (maxXValue) {
        case 2:
          for (var wid in showedWidgets) {
            data.add(
              ChartData(wid.countryCode!.toUpperCase(), wid.biValue),
            );
          }
          break;
        case 3:
          for (var wid in showedWidgets) {
            data.add(
              ChartData(wid.portCode!.toUpperCase(), wid.biValue),
            );
          }
          break;
        case 4:
          for (var wid in showedWidgets) {
            data.add(
              ChartData(wid.terminalCode!.toUpperCase(), wid.biValue),
            );
          }
          break;
        case 5:
          for (var wid in showedWidgets) {
            data.add(
              ChartData(wid.operatorCode!.toUpperCase(), wid.biValue),
            );
          }
          break;
        default:
          for (var wid in showedWidgets) {
            data.add(
              ChartData(wid.countryCode!.toUpperCase(), wid.biValue),
            );
          }
          break;
      }
    }
  }

  void prepareYAxis() {
    if (widgetDetails.isNotEmpty) {
      maxItem = widgetDetails.reduce((value, element) =>
          value.biValue > element.biValue ? value : element);
      minItem = widgetDetails.reduce((value, element) =>
          value.biValue < element.biValue ? value : element);
      minVal = double.parse(minItem.biValue.toString());
      maxVal = double.parse(maxItem.biValue.toString());
      if (widget.chartType == "GDPGR" && minVal < 0) {
        minVal = -150;
        maxVal = 150;

        interval = 75;
      } else {
        minVal = minVal > 0 ? 0 : 1.5 * minVal;

        maxVal = 1.5 * maxVal;
        interval = ((maxVal - minVal) / 4);
      }
    }
  }

  void getWidgetDetails() {
    switch (widget.chartType) {
      case "GDP":
      case "GDPGR":
      case "POP":
        widgetDetails = widget.bidWidgetDetails
            .where(
              (wid) =>
                  wid.biType?.toUpperCase() == widget.chartType.toUpperCase() &&
                  wid.xValue == 2,
            )
            .toList();
        widgetDetails.sort((a, b) => b.countryCode!.compareTo(a.countryCode!));
        break;

      case "VOL":
        widgetDetails = widget.bidWidgetDetails
            .where((wid) =>
                wid.biType?.toUpperCase() == widget.chartType.toUpperCase())
            .toList();
        if (widgetDetails.isNotEmpty) {
          maxXValue = widgetDetails
              .reduce((value, element) =>
                  value.xValue > element.xValue ? value : element)
              .xValue;

          widgetDetails = widget.bidWidgetDetails
              .where((wid) =>
                  wid.biType?.toUpperCase() == widget.chartType.toUpperCase() &&
                  wid.xValue == maxXValue)
              .toList();
          widgetDetails
              .sort((a, b) => b.countryCode!.compareTo(a.countryCode!));
        }

        break;

      default:
    }
  }

  @override
  void initState() {
    getWidgetDetails();
    if (widgetDetails.isNotEmpty) {
      showedWidgets = widgetDetails
          .where((wid) => wid.biYearDisplay == widget.yearList[0])
          .toList();
      setChartXvalue();
      prepareYAxis();

      _tooltip = TooltipBehavior(enable: true);
      _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        // enablePinching: true,
        enablePanning: true,
      );

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
                    Color.fromRGBO(213, 213, 221, 1),
                    Color.fromRGBO(213, 213, 221, 1).withOpacity(0.8),
                    Color.fromRGBO(213, 213, 221, 1).withOpacity(0.5),
                    Color.fromRGBO(213, 213, 221, 1).withOpacity(0.1),
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

    Widget buildChart() {
      return SfCartesianChart(
          enableAxisAnimation: true,
          isTransposed: true,
          margin: EdgeInsets.only(bottom: 5),
          zoomPanBehavior: _zoomPanBehavior,
          primaryXAxis: CategoryAxis(
            arrangeByIndex: true,
            autoScrollingDelta: 8,
            interval: 1,
            labelStyle: TextStyle(
                fontFamily: 'Pilat Demi',
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          primaryYAxis: NumericAxis(
            opposedPosition: true,
            edgeLabelPlacement: EdgeLabelPlacement.none,
            decimalPlaces: 1,
            minimum: widget.minVal,
            maximum: widget.maxVal,
            interval: widget.interval,
            labelFormat: ' {value} ${widgetDetails[0].biUnit}',
            labelStyle: TextStyle(
              fontFamily: 'Pilat Demi',
              fontSize: 12,
            ),
          ),
          tooltipBehavior: _tooltip,
          series: <ChartSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  alignment: ChartAlignment.center,
                  labelAlignment: ChartDataLabelAlignment.outer,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    letterSpacing: 1,
                    color: Colors.black,
                    fontFamily: 'Pilat Demi',
                    fontSize: 12,
                  ),
                  // Renders the data label
                  isVisible: true,
                ),
                dataSource: data,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                name: widget.chartTitle,
                color: Colors.indigo[900],
                pointColorMapper: (ChartData data, _) {
                  if (data.y < 0) {
                    return Color.fromRGBO(255, 0, 0, 1);
                  } else {
                    return Colors.indigo[900];
                  }
                }),
          ]);
    }
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
                  Color.fromRGBO(213, 213, 221, 1),
                  Color.fromRGBO(213, 213, 221, 1).withOpacity(0.8),
                  Color.fromRGBO(213, 213, 221, 1).withOpacity(0.5),
                  Color.fromRGBO(213, 213, 221, 1).withOpacity(0.1),
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

  Widget buildChart() {
    return SfCartesianChart(
        enableAxisAnimation: true,
        isTransposed: true,
        margin: EdgeInsets.only(bottom: 5),
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: CategoryAxis(
          arrangeByIndex: true,
          autoScrollingDelta: 8,
          interval: 1,
          labelStyle: TextStyle(
              fontFamily: 'Pilat Demi',
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          edgeLabelPlacement: EdgeLabelPlacement.none,
          decimalPlaces: 1,
          minimum: widget.minVal,
          maximum: widget.maxVal,
          interval: widget.interval,
          labelFormat: ' {value} ${widgetDetails[0].biUnit}',
          labelStyle: TextStyle(
            fontFamily: 'Pilat Demi',
            fontSize: 12,
          ),
        ),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(
                alignment: ChartAlignment.center,
                labelAlignment: ChartDataLabelAlignment.outer,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(
                  letterSpacing: 1,
                  color: Colors.black,
                  fontFamily: 'Pilat Demi',
                  fontSize: 12,
                ),
                // Renders the data label
                isVisible: true,
              ),
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: widget.chartTitle,
              color: Colors.indigo[900],
              pointColorMapper: (ChartData data, _) {
                if (data.y < 0) {
                  return Color.fromRGBO(255, 0, 0, 1);
                } else {
                  return Colors.indigo[900];
                }
              }),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 40, left: 30, bottom: 70),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.chartTitle,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontFamily: 'Pilat Heavy',
                fontSize: 20,
              ),
            ),
            widgetDetails.isNotEmpty
                ? DropdownButton(
                    dropdownColor: Colors.white,
                    value: showedYear,
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color.fromRGBO(50, 48, 190, 1),
                    ),
                    items:
                        widget.yearList.map<DropdownMenuItem<String>>((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(50, 48, 190, 1),
                              fontFamily: 'Pilat Heavy',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        showedYear = newValue!;
                        showedWidgets = widgetDetails
                            .where((wid) => wid.biYearDisplay == newValue)
                            .toList();

                        data.clear();

                        for (var wid in showedWidgets) {
                          data.add(
                            ChartData(
                                wid.countryCode!.toUpperCase(), wid.biValue),
                          );
                        }
                      });
                    },
                  )
                : SizedBox(),
          ],
        ),
        buildGredientLine(
          mediaQuery,
          theme,
        ),
        Expanded(
          child: widgetDetails.isNotEmpty
              ? buildChart()
              : Center(
                  child: Text("No Data Found"),
                ),
        ),
      ]),
    );
  }
}
