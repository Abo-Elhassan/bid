import 'package:bid_app/app/core/values/app_assets.dart';
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
          Assets.kSplashBackground,
          alignment: Alignment.center,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ]),
    );
  }
}
