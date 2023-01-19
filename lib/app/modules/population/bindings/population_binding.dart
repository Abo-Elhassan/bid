import 'package:get/get.dart';

import '../controllers/population_controller.dart';

class PopulationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PopulationController>(
      () => PopulationController(),
    );
  }
}
