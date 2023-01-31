import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilteredBIDChartView extends StatefulWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  final String chartType;
  final String chartTitle;

  FilteredBIDChartView(
    this.bidWidgetDetails,
    this.chartType,
    this.chartTitle,
  );

  @override
  FilteredBIDChartViewState createState() => FilteredBIDChartViewState();
}

class FilteredBIDChartViewState extends State<FilteredBIDChartView> {
  late List<ChartData> data = <ChartData>[];
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = <BidWidgetDetails>[];
  final yearList = <int>[];

  late List<BidWidgetDetails> showedWidgets = widgetDetails;

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

      minVal = minVal > 0 ? minVal - 0.5 * minVal : minVal + (0.5 * minVal);

      maxVal = maxVal + 0.75 * maxVal;
      interval = ((maxVal - minVal) / 2);
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
        }

        break;

      default:
    }
  }

  @override
  void initState() {
    getWidgetDetails();
    if (widgetDetails.isNotEmpty) {
      widgetDetails.distinct(((wid) => wid.biYear)).toList().forEach((item) {
        yearList.add(item.biYear);
      });

      showedWidgets =
          widgetDetails.where((wid) => wid.biYear == yearList[0]).toList();
      setChartXvalue();
      prepareYAxis();

      _tooltip = TooltipBehavior(enable: true);
      _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        // enablePinching: true,
        enablePanning: true,
      );
    }
    super.initState();
  }

  Column buildChart() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SfCartesianChart(
                  enableAxisAnimation: true,
                  isTransposed: true,
                  zoomPanBehavior: _zoomPanBehavior,
                  primaryXAxis: CategoryAxis(
                    autoScrollingDelta: 5,
                    interval: 1,
                  ),
                  primaryYAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    decimalPlaces: 0,
                    minimum: minVal,
                    maximum: maxVal,
                    interval: interval,
                    labelFormat: ' {value} ${widgetDetails[0].biUnit}',
                  ),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                        dataLabelSettings: DataLabelSettings(
                          alignment: ChartAlignment.center,
                          labelAlignment: ChartDataLabelAlignment.outer,
                          labelPosition: ChartDataLabelPosition.outside,

                          textStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pilat ',
                            fontSize: 14,
                          ),
                          // Renders the data label
                          isVisible: true,
                        ),
                        dataSource: data,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        name: widget.chartTitle,
                        color: Colors.indigo[900]),
                  ]),
            ),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              alignment: Alignment.centerRight,
              onPressed: () {
                var pageRoute = "";
                switch (widget.chartTitle.toUpperCase()) {
                  case "GDP":
                    pageRoute = Routes.GDP;

                    break;
                  case "GDPGR":
                    pageRoute = Routes.GDPGR;

                    break;
                  case "POPULATION":
                    pageRoute = Routes.POPULATION;

                    break;
                  case "VOLUME":
                    pageRoute = Routes.VOLUME;

                    break;

                  default:
                }
                Get.toNamed(pageRoute, arguments: {
                  "bidWidgetDetails": widgetDetails,
                  "chartType": widget.chartType,
                  "chartTitle": widget.chartTitle,
                  "chartData": data,
                  "yearList": yearList,
                  "minVal": minVal,
                  "maxVal": maxVal,
                  "interval": interval,
                });
              },
              icon: Icon(Icons.arrow_forward)),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.chartTitle,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontFamily: 'Pilat Heavy',
                fontSize: 16,
              ),
            ),
            widgetDetails.isNotEmpty
                ? DropdownButton(
                    dropdownColor: Colors.white,
                    value: showedWidgets[0].biYear,
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color.fromRGBO(50, 48, 190, 1),
                    ),
                    items: widgetDetails
                        .distinct(((wid) => wid.biYear))
                        .toList()
                        .map<DropdownMenuItem<int>>((wid) {
                      return DropdownMenuItem(
                        value: wid.biYear,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            wid.biYearDisplay.toString(),
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
                        showedWidgets = widgetDetails
                            .where((wid) => wid.biYear == newValue)
                            .toList();

                        data.clear();

                        setChartXvalue();
                      });
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
      Container(
        height: 400,
        width: double.infinity,
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 10),
            child: widgetDetails.isNotEmpty
                ? buildChart()
                : Center(
                    child: Text("No Data Found"),
                  ),
          ),
        ),
      )
    ]);
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
