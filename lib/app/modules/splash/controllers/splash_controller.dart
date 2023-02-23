import 'dart:io';

import 'package:bid_app/app/routes/app_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:get/get.dart';
import 'package:root_check/root_check.dart';

class SplashController extends GetxController {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    initApplication();

    super.onReady();
  }

  void initApplication() async {
    Future.delayed(Duration(seconds: 4), () async {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        FlutterJailbreakDetection.developerMode.then((value) {
          if (value || !(androidInfo.isPhysicalDevice)) {
            Get.offAllNamed(Routes.ERROR);
          } else {
            Get.offAllNamed(Routes.LANDING);
          }
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        FlutterJailbreakDetection.jailbroken.then((value) {
          //   if (value == true || !iosInfo.isPhysicalDevice) {
          //    Get.offNamed(Routes.ERROR);
          //  } else {
          Get.offAllNamed(Routes.LANDING);
          //  }
        });
      }

      RootCheck.isRooted.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });

      RootCheck.isRootedWithBusyBoxCheck.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });

      RootCheck.checkForRootNative.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });

      RootCheck.detectPotentiallyDangerousApps.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });

      RootCheck.detectTestKeys.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });

      RootCheck.checkForDangerousProps.then((value) {
        if (value != null && value) {
          Get.offAllNamed(Routes.ERROR);
        }
      });
    });
  }
}
