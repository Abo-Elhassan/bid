import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:get/get.dart';

class GdpController extends GetxController {
  final routeArguments = Get.arguments as Map<String, dynamic>;
  late List<BidWidgetDetails> bidWidgetDetails =
      routeArguments['bidWidgetDetails'];
  late String chartType = routeArguments['chartType'];
  late String chartTitle = routeArguments['chartTitle'];
}
