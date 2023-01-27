import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({Key? key}) : super(key: key);
  final cont = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/splash_background.gif',
          alignment: Alignment.center,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ]),
    );
  }
}
