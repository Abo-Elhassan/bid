import 'package:bid_app/app/data/utilities/charts/filtered_bid_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gdp_controller.dart';

class GdpView extends GetView<GdpController> {
  const GdpView({Key? key}) : super(key: key);
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
