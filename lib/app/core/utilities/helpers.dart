import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Helpers {
  static LoginResponse getCurrentUser() {
    final localStorage = GetStorage();
    final loginResponse =
        LoginResponse.fromJson(localStorage.read('loginResponse'));
    return loginResponse;
  }

  static Widget loadingIndicator() {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(Get.context!).size.height * 0.8,
        width: MediaQuery.of(Get.context!).size.width,
        child: SpinKitCubeGrid(
          color: Theme.of(Get.context!).colorScheme.secondary,
          size: 40,
        ),
      ),
    );
  }

  static Future<bool> checkConnectivity() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> dialog(
      IconData icon, Color iconColor, String content) async {
    await showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: Icon(
          icon,
          color: iconColor,
          size: 80,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Exit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }
}
