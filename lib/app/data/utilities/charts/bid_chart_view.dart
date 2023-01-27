import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/routes/app_pages.dart';
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
  late List<_ChartData> data;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = <BidWidgetDetails>[];

  late BidWidgetDetails maxItem = BidWidgetDetails();
  late BidWidgetDetails minItem = BidWidgetDetails();
  late double minVal = 0;
  late double maxVal = 0;

  @override
  void initState() {
    widgetDetails = widget.bidWidgetDetails
        .where(
          (wid) => wid.biType?.toUpperCase() == widget.chartType.toUpperCase(),
        )
        .toList();
    if (widgetDetails.isNotEmpty) {
      maxItem = widgetDetails.reduce((value, element) =>
          value.biValue > element.biValue ? value : element);
      minItem = widgetDetails.reduce((value, element) =>
          value.biValue < element.biValue ? value : element);
      minVal = double.parse(minItem.biValue.toString());
      maxVal = double.parse(maxItem.biValue.toString());

      _tooltip = TooltipBehavior(enable: true);
      _zoomPanBehavior = ZoomPanBehavior(
          // Enables pinch zooming
          // enablePinching: true,
          );
      data = [];
      for (var wid in widgetDetails) {
        if (widget.filterData.terminalList!
            .any((terminal) => terminal.isSelected)) {
          data.add(
            _ChartData(wid.terminalCode!.toUpperCase(), wid.biValue),
          );
        } else if (widget.filterData.portList!.any((port) => port.isSelected)) {
          data.add(
            _ChartData(wid.portCode!.toUpperCase(), wid.biValue),
          );
        } else {
          data.add(
            _ChartData(wid.countryCode!.toUpperCase(), wid.biValue),
          );
        }
      }
    }

    super.initState();
  }

  NumericAxis buildYAxis() {
    if (widgetDetails.length == 1) {
      return NumericAxis(
          numberFormat: NumberFormat.compact(),
          decimalPlaces: 2,
          minimum: minVal - 0.5 * minVal > 0 ? minVal - 0.5 * minVal : 0,
          maximum: minVal * 3,
          interval: minVal + 0.5 * minVal / 2);
    } else {
      return NumericAxis(
          numberFormat: NumberFormat.compact(),
          decimalPlaces: 2,
          minimum:
              minVal - (maxVal - minVal) > 0 ? minVal - (maxVal - minVal) : 0,
          maximum: maxVal + (maxVal - minVal),
          interval: (maxVal - minVal) / 2);
    }
  }

  Column buildChart() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: SfCartesianChart(
                isTransposed: false,
                margin: EdgeInsets.only(bottom: 5),
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(
                  maximumLabels: widgetDetails.length,
                  labelRotation: -45,
                  // title: AxisTitle(text: "Country")
                ),
                primaryYAxis: buildYAxis(),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                      dataLabelSettings: DataLabelSettings(
                        alignment: ChartAlignment.far,
                        labelAlignment: ChartDataLabelAlignment.outer,
                        labelPosition: ChartDataLabelPosition.outside,
                        angle: -90,
                        textStyle: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontFamily: 'Pilat Heavy',
                          fontSize: 10,
                        ),
                        // Renders the data label
                        isVisible: true,
                      ),
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: widget.chartTitle,
                      color: Colors.indigo[900]),
                ]),
          ),
          IconButton(
              padding: EdgeInsets.zero,
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
                  "chartType": widget.chartType,
                  "chartTitle": widget.chartTitle,
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
          ],
        ),
      ),
      SizedBox(
        height: 10,
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
