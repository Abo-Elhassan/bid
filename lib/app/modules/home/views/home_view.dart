import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/modules/home/views/home_content.dart';
import 'package:bid_app/shared/page_layout.dart';

import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/modules/home/views/home_content.dart';
import 'package:bid_app/shared/page_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HomeContent();
  }
}
