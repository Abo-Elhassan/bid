import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NatureOfInvolvementController extends GetxController {
  final noiData = Get.arguments as List<BidWidgetDetails>;

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
}
