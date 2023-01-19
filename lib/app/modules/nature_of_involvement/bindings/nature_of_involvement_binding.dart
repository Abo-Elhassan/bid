import 'package:get/get.dart';

import '../controllers/nature_of_involvement_controller.dart';

class NatureOfInvolvementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NatureOfInvolvementController>(
      () => NatureOfInvolvementController(),
    );
  }
}
