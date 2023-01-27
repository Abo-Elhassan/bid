import 'package:bid_app/app/data/utilities/charts/bid_chart.dart';
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
        controller.bidWidgetDetails,
        controller.filterData,
        "DEVELOPEMENT",
        "DEVELOPEMENT",
      ),
    );
  }
}
