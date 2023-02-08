import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BIDChartView extends StatefulWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  final FilterDataResponse filterData;
  final String chartType;
  final String chartTitle;

  BIDChartView(
    this.bidWidgetDetails,
    this.filterData,
    this.chartType,
    this.chartTitle,
  );

  @override
  BIDChartState createState() => BIDChartState();
}

class BIDChartState extends State<BIDChartView> {
  late List<ChartData> data = <ChartData>[];
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = <BidWidgetDetails>[];
  final yearList = <String>[];

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

      minVal = minVal > 0 ? 0 : 1.5 * minVal;

      maxVal = 1.5 * maxVal;
      interval = ((maxVal - minVal) / 4);
    }
  }

  void getWidgetDetails() {
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
  }

  @override
  void initState() {
    getWidgetDetails();
    if (widgetDetails.isNotEmpty) {
      widgetDetails
          .distinct(((wid) => wid.biYearDisplay.toString()))
          .toList()
          .forEach((item) {
        yearList.add(item.biYearDisplay.toString());
      });

      showedWidgets = widgetDetails
          .where((wid) => wid.biYearDisplay == yearList[0])
          .toList();
      setChartXvalue();
      prepareYAxis();

      _tooltip = TooltipBehavior(enable: true, duration: 1);
      _zoomPanBehavior = ZoomPanBehavior(
          // Enables pinch zooming
          // enablePinching: true,
          // enablePanning: true,
          );
    }

    super.initState();
  }

  Column buildChart() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: SfCartesianChart(
                // enableAxisAnimation: true,
                isTransposed: false,
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(
                  labelRotation: -90,
                  majorGridLines: MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  interval: 1,
                  maximumLabels: 8,
                  visibleMinimum: 0,
                  visibleMaximum: widgetDetails.length > 8 ? 8 : null,
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  //Hide the axis line of x-axis
                  axisLine: AxisLine(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.none,
                  decimalPlaces: 1,
                  minimum: minVal,
                  maximum: maxVal,
                  interval: interval,
                  labelFormat: ' {value} ${widgetDetails[0].biUnit}',
                ),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                      // dataLabelSettings: DataLabelSettings(
                      //   alignment: ChartAlignment.center,
                      //   labelAlignment: ChartDataLabelAlignment.outer,
                      //   labelPosition: ChartDataLabelPosition.outside,

                      //   textStyle: TextStyle(
                      //     color: Colors.black,
                      //     fontFamily: 'Pilat',
                      //     fontSize: 14,
                      //   ),
                      //   // Renders the data label
                      //   isVisible: true,
                      // ),
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: widget.chartTitle,
                      color: Colors.indigo[900]),
                ]),
          ),
          IconButton(
              padding: EdgeInsets.only(right: 10),
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              alignment: Alignment.centerRight,
              onPressed: () {
                var pageRoute = "";
                switch (widget.chartTitle.toUpperCase()) {
                  case "CAPACITY":
                    pageRoute = Routes.CAPACITY;

                    break;
                  case "DEVELOPMENT":
                    pageRoute = Routes.DEVELOPEMENT;

                    break;
                  default:
                }
                Get.toNamed(pageRoute, arguments: {
                  "bidWidgetDetails": widget.bidWidgetDetails,
                  "filterData": widget.filterData,
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
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 0, top: 20, bottom: 10),
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
