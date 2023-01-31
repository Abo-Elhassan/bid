import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/utilities/charts/filtered_bid_chart_view.dart';
import 'package:get/get.dart';

class GdpgrController extends GetxController {
  final routeArguments = Get.arguments as Map<String, dynamic>;
  late List<BidWidgetDetails> widgetDetails =
      routeArguments['bidWidgetDetails'];
  late List<BidWidgetDetails> showedWidgets = widgetDetails;
  late String chartType = routeArguments['chartType'];
  late String chartTitle = routeArguments['chartTitle'];
  late List<ChartData> data = routeArguments['chartData'];
  late List<int> yearList = routeArguments['yearList'];
  late double minVal = routeArguments['minVal'];
  late double maxVal = routeArguments['maxVal'];
  late double? interval = routeArguments['interval'];
}
