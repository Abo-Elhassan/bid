import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilteredBIDChart extends StatefulWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  final String chartType;
  final String chartTitle;

  FilteredBIDChart(
    this.bidWidgetDetails,
    this.chartType,
    this.chartTitle,
  );

  @override
  FilteredBIDChartState createState() => FilteredBIDChartState();
}

class FilteredBIDChartState extends State<FilteredBIDChart> {
  late List<_ChartData> data;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = <BidWidgetDetails>[];
  final yearList = <int>[];

  late List<BidWidgetDetails> showedWidgets = widgetDetails;

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
      widgetDetails.distinct(((wid) => wid.biYear)).toList().forEach((item) {
        yearList.add(item.biYear);
      });

      showedWidgets =
          widgetDetails.where((wid) => wid.biYear == yearList[0]).toList();

      maxItem = widgetDetails.reduce((value, element) =>
          value.biValue > element.biValue ? value : element);
      minItem = widgetDetails.reduce((value, element) =>
          value.biValue < element.biValue ? value : element);
      minVal = double.parse(minItem.biValue.toString());
      maxVal = double.parse(maxItem.biValue.toString());
    }

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
        isTransposed: true,
        margin: EdgeInsets.only(bottom: 5),
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Pilat Demi',
              fontSize: 12,
              fontWeight: FontWeight.bold),
          maximumLabels: widgetDetails.length,
        ),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compact(),
            decimalPlaces: 2,
            minimum:
                minVal - (maxVal - minVal) > 0 ? minVal - (maxVal - minVal) : 0,
            maximum: maxVal + (maxVal - minVal),
            interval: (maxVal - minVal) / 2),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataLabelSettings: DataLabelSettings(
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

                        for (var wid in showedWidgets) {
                          data.add(
                            _ChartData(
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
