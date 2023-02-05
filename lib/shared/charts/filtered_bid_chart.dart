import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/shared/charts/filtered_bid_chart_view.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FilteredBIDChart extends StatefulWidget {
  final List<BidWidgetDetails> widgetDetails;
  final String chartType;
  final String chartTitle;
  late List<BidWidgetDetails> showedWidgets;
  late List<ChartData> data;
  final List<int> yearList;
  final double minVal;
  final double maxVal;
  final double? interval;

  FilteredBIDChart({
    required this.widgetDetails,
    required this.chartType,
    required this.chartTitle,
    required this.showedWidgets,
    required this.data,
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
  late int showedYear = widget.yearList[0];
  @override
  void initState() {
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
          labelFormat: ' {value} ${widget.widgetDetails[0].biUnit}',
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
              dataSource: widget.data,
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
            widget.widgetDetails.isNotEmpty
                ? DropdownButton(
                    dropdownColor: Colors.white,
                    value: showedYear,
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color.fromRGBO(50, 48, 190, 1),
                    ),
                    items: widget.yearList.map<DropdownMenuItem<int>>((year) {
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
                        widget.showedWidgets = widget.widgetDetails
                            .where((wid) => wid.biYear == newValue)
                            .toList();

                        widget.data.clear();

                        for (var wid in widget.showedWidgets) {
                          widget.data.add(
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
          child: widget.widgetDetails.isNotEmpty
              ? buildChart()
              : Center(
                  child: Text("No Data Found"),
                ),
        ),
      ]),
    );
  }
}
