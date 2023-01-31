import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: Stack(fit: StackFit.expand, children: [
        Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.kBackground), fit: BoxFit.cover)),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white30,
            backgroundBlendMode: BlendMode.multiply,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: mediaQuery.size.width * 0.1,
              horizontal: mediaQuery.size.width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.1,
              ),
              Image.asset(
                Assets.kDpLogo,
                height: mediaQuery.size.height * 0.16,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                'DP INSIGHTS & WEATHER FORECAST',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pilat Heavy',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pilat Heavy',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.5,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.offNamed(Routes.LOGIN),
                  splashColor: const Color.fromRGBO(236, 236, 255, 1),
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    Assets.kStart,
                    height: mediaQuery.size.width * 0.17,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
