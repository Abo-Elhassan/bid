import 'dart:io';

import 'package:bid_app/app/routes/app_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';

class LandingController extends GetxController {
  @override
  void onInit() async {
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: Get.context!);
    super.onInit();
  }
}
