import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/error_controller.dart';

class ErrorView extends GetView<ErrorController> {
  const ErrorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ACCESS DENIED",
          style: TextStyle(fontSize: 25, color: Colors.red),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Your device is not secured to use this application, If developer mode is opened please close it to use this application',
            style: TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
