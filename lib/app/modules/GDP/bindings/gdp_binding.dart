import 'package:get/get.dart';

import '../controllers/gdp_controller.dart';

class GdpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GdpController>(
      () => GdpController(),
    );
  }
}
