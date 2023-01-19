import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BIDChartWithoutFilter extends StatefulWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  final FilterDataResponse filterData;
  final String chartType;
  final String chartTitle;

  BIDChartWithoutFilter(
    this.bidWidgetDetails,
    this.filterData,
    this.chartType,
    this.chartTitle,
  );

  @override
  BIDChartWithoutFilterState createState() => BIDChartWithoutFilterState();
}

class BIDChartWithoutFilterState extends State<BIDChartWithoutFilter> {
  late List<_ChartData> data;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltip;
  late List<BidWidgetDetails> widgetDetails = widget.bidWidgetDetails
      .where((widg) => widg.biType == "CAPACITY")
      .toList();

  late BidWidgetDetails maxItem = BidWidgetDetails();
  late BidWidgetDetails minItem = BidWidgetDetails();
  late double minVal = 0;
  late double maxVal = 0;

  @override
  void initState() {
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
    super.initState();
  }

  NumericAxis buildYAxis() {
    if (widgetDetails.length == 1) {
      return NumericAxis(
          decimalPlaces: 0,
          minimum: minVal - 0.5 * minVal > 0 ? minVal - 0.5 * minVal : 0,
          maximum: minVal * 3,
          interval: minVal + 0.5 * minVal / 2);
    } else {
      return NumericAxis(
          decimalPlaces: 0,
          minimum:
              minVal - (maxVal - minVal) > 0 ? minVal - (maxVal - minVal) : 0,
          maximum: maxVal + (maxVal - minVal),
          interval: (maxVal - minVal) / 2);
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
        primaryYAxis: buildYAxis(),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataLabelSettings: DataLabelSettings(
                textStyle: TextStyle(
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
                fontSize: 16,
              ),
            ),
          ],
        ),
        buildGredientLine(
          mediaQuery,
          theme,
        ),
        Expanded(child: buildChart()),
      ]),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
