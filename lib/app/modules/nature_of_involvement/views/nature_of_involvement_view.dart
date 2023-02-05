import 'package:bid_app/shared/charts/noi.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/nature_of_involvement_controller.dart';

class NatureOfInvolvementView extends GetView<NatureOfInvolvementController> {
  const NatureOfInvolvementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NATURE OF INVOLVEMENT",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontFamily: 'Pilat Heavy',
                  fontSize: 16,
                ),
              ),
              controller.buildGredientLine(
                mediaQuery,
                theme,
              ),
              NatureOfInvolvement(
                controller.noiData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
