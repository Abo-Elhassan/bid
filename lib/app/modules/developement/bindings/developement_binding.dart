import 'package:get/get.dart';

import '../controllers/developement_controller.dart';

class DevelopementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevelopementController>(
      () => DevelopementController(),
    );
  }
}
