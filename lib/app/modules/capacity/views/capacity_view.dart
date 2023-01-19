import 'package:bid_app/app/data/utilities/charts/bid_chart_without_filter.dart';
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
      body: BIDChartWithoutFilter(
        controller.bidWidgetDetails,
        controller.filterData,
        "CAPACITY",
        "CAPACITY",
      ),
    );
  }
}
