import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/bid_provider.dart';
import 'package:get/get.dart';

class WidgetDataProvider extends BidProvider {
  Future<FilterDataResponse> getBIDFilterData(FilterDataRequest request) async {
    try {
      var body = request.toJson();
      final response = await post('/BID/GetBIDFilterData', body);
      late FilterDataResponse filterDataResponse = FilterDataResponse();
      if (response.statusCode == 401) {
        filterDataResponse.statusCode = 401;
        return filterDataResponse;
      } else if (response.statusCode == 500) {
        filterDataResponse.statusCode = 500;
        return filterDataResponse;
      }
      filterDataResponse = FilterDataResponse.fromJson(response.body);
      return filterDataResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<WidgetDataResponse> getBIDashboardWidgetData(
      WidgetDataRequest request) async {
    try {
      var body = request.toJson();
      final response = await post('/BID/GetBIDashboardWidgetData', body);
      late WidgetDataResponse widgetDataResponse = WidgetDataResponse();
      if (response.statusCode == 401) {
        widgetDataResponse.statusCode = 401;
        return widgetDataResponse;
      } else if (response.statusCode == 500) {
        widgetDataResponse.statusCode = 500;
        return widgetDataResponse;
      }

      if (response.body != null) {
        widgetDataResponse = WidgetDataResponse.fromJson(response.body);
      }

      return widgetDataResponse;
    } catch (e) {
      rethrow;
    }
  }
}
