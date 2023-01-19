import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BIDChartView extends StatefulWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  final String chartType;
  final String chartTitle;

  BIDChartView(
    this.bidWidgetDetails,
    this.chartType,
    this.chartTitle,
  );

  @override
  BIDChartViewState createState() => BIDChartViewState();
}

class BIDChartViewState extends State<BIDChartView> {
  late List<_ChartData> data;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = widget.bidWidgetDetails
      .where(
          (wid) => wid.biType?.toUpperCase() == widget.chartType.toUpperCase())
      .toList();
  final yearList = <int>[];

  late List<BidWidgetDetails> showedWidgets = widgetDetails;

  late BidWidgetDetails maxItem = BidWidgetDetails();
  late BidWidgetDetails minItem = BidWidgetDetails();
  late double minVal = 0;
  late double maxVal = 0;

  @override
  void initState() {
    widgetDetails.distinct(((wid) => wid.biYear)).toList().forEach((item) {
      yearList.add(item.biYear);
    });

    showedWidgets =
        widgetDetails.where((wid) => wid.biYear == yearList[0]).toList();

    maxItem = widgetDetails.reduce(
        (value, element) => value.biValue > element.biValue ? value : element);
    minItem = widgetDetails.reduce(
        (value, element) => value.biValue < element.biValue ? value : element);
    minVal = double.parse(minItem.biValue.toString());
    maxVal = double.parse(maxItem.biValue.toString());
    _tooltip = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        // enablePinching: true,
        );

    data = <_ChartData>[];
    for (var wid in showedWidgets) {
      data.add(
        _ChartData(wid.countryCode!.toUpperCase(), wid.biValue),
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
                isTransposed: false,
                margin: EdgeInsets.only(bottom: 5),
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(
                  maximumLabels: widgetDetails.length,
                  labelRotation: -45,
                ),
                primaryYAxis: NumericAxis(
                    decimalPlaces: 0,
                    minimum: minVal - (maxVal - minVal) > 0
                        ? minVal - (maxVal - minVal)
                        : 0,
                    maximum: maxVal + (maxVal - minVal),
                    interval: (maxVal - minVal) / 2),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
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
            DropdownButton(
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
                      wid.biYear.toString(),
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

                  for (var wid in showedWidgets) {
                    data.add(
                      _ChartData(wid.countryCode!.toUpperCase(), wid.biValue),
                    );
                  }
                });
              },
            ),
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
            child: buildChart(),
          ),
        ),
      )
    ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
