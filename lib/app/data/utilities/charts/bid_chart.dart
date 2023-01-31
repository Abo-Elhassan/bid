import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/utilities/charts/filtered_bid_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BIDChart extends StatefulWidget {
  final List<BidWidgetDetails> widgetDetails;
  final FilterDataResponse filterData;
  final String chartType;
  final String chartTitle;
  late List<BidWidgetDetails> showedWidgets;
  late List<ChartData> data;
  final List<int> yearList;
  final double minVal;
  final double maxVal;
  final double? interval;

  BIDChart({
    required this.widgetDetails,
    required this.filterData,
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
  BIDChartState createState() => BIDChartState();
}

class BIDChartState extends State<BIDChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;

  late double maxVal = 0;

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
          autoScrollingDelta: 8,
          interval: 1,
          labelStyle: TextStyle(
              fontFamily: 'Pilat Demi',
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          opposedPosition: true,
          decimalPlaces: 0,
          minimum: widget.minVal,
          maximum: widget.maxVal,
          interval: widget.interval,
          labelFormat: ' {value} ${widget.widgetDetails[0].biUnit}',
          labelStyle: TextStyle(
            fontFamily: 'Pilat Demi',
            fontSize: 14,
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
                  fontSize: 16,
                ),
                // Renders the data label
                isVisible: true,
              ),
              dataSource: widget.data,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
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
                fontSize: 16,
              ),
            ),
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
