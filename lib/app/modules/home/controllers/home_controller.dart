import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/weather_forecast_request.dart';
import 'package:bid_app/app/data/models/requests/widget_data_reqeuest.dart';
import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/providers/weather_forecast_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';

class HomeController extends GetxController {
  final localStorage = GetStorage();
  late WidgetDataResponse widgetsData = WidgetDataResponse();
  late FilterDataResponse filterData = FilterDataResponse();
  RxBool isLoading = false.obs;
  @override
  void onInit() async {
    super.onInit();
  }
}
