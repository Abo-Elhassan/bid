import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  //TODO: Implement LandingController

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> cachImages() async {
    await precacheImage(
        const AssetImage("assets/images/background.png"), Get.context!);
    await precacheImage(
        const AssetImage("assets/images/splash.png"), Get.context!);

    await precacheImage(
        const AssetImage("assets/images/START.png"), Get.context!);
  }
}
