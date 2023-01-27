import 'package:bid_app/app/data/utilities/charts/filtered_bid_chart.dart';
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
        controller.bidWidgetDetails,
        "GDPGR",
        "GDPGR",
      ),
    );
  }
}
