import 'package:get/get.dart';

import '../controllers/volume_controller.dart';

class VolumeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VolumeController>(
      () => VolumeController(),
    );
  }
}
