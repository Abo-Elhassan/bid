import 'package:get/get.dart';

import '../controllers/gdpgr_controller.dart';

class GdpgrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GdpgrController>(
      () => GdpgrController(),
    );
  }
}
