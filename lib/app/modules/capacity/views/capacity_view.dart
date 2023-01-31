import 'package:bid_app/app/data/utilities/charts/bid_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/capacity_controller.dart';

class CapacityView extends GetView<CapacityController> {
  const CapacityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BIDChart(
        widgetDetails: controller.widgetDetails,
        filterData: controller.filterData,
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
