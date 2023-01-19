import 'package:get/get.dart';

import '../controllers/capacity_controller.dart';

class CapacityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CapacityController>(
      () => CapacityController(),
    );
  }
}
