import 'package:bid_app/shared/charts/bid_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/developement_controller.dart';

class DevelopementView extends GetView<DevelopementController> {
  const DevelopementView({Key? key}) : super(key: key);
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
