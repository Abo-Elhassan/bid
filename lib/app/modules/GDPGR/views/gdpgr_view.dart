import 'package:bid_app/shared/charts/filtered_bid_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gdpgr_controller.dart';

class GdpgrView extends GetView<GdpgrController> {
  const GdpgrView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FilteredBIDChart(
        widgetDetails: controller.widgetDetails,
        chartType: controller.chartType,
        chartTitle: controller.chartTitle,
        showedWidgets: controller.showedWidgets,
        data: controller.data,
        yearList: controller.yearList,
        minVal: controller.minVal,
        maxVal: controller.maxVal,
        interval: controller.interval,
      ),
    );
  }
}
