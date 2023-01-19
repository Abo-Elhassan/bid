import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/nature_of_involvement_controller.dart';

class NatureOfInvolvementView extends GetView<NatureOfInvolvementController> {
  const NatureOfInvolvementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NatureOfInvolvementView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'NatureOfInvolvementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
