import 'dart:math';

import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    return Scaffold(
      body: GetX<LoginController>(
        init: LoginController(),
        builder: (controller) => (Visibility(
          visible: controller.isloading.isFalse,
          replacement: Helpers.loadingIndicator(),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  Assets.kEarthLines,
                  height: mediaQuery.size.height * 0.24,
                  opacity: const AlwaysStoppedAnimation(.4),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: mediaQuery.size.height * 0.1,
                  right: mediaQuery.size.width * 0.08,
                  left: mediaQuery.size.width * 0.08,
                  bottom: mediaQuery.viewInsets.bottom * 0.1,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        Assets.kDpLogo,
                        height: mediaQuery.size.height * 0.15,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.08,
                      ),
                      Form(
                        key: controller.formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              controller.buildTextInput(
                                  controller.usernameController,
                                  'User Name',
                                  'Please enter your user name here',
                                  TextInputType.text),
                              SizedBox(
                                height: mediaQuery.size.height * 0.05,
                              ),
                              controller.buildTextInput(
                                  controller.passwordController,
                                  'Password',
                                  'Please enter your password here',
                                  TextInputType.text),
                            ]),
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.1,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.saveForm(
                                controller.usernameController.text,
                                controller.passwordController.text);
                          },
                          splashColor: const Color.fromRGBO(236, 236, 255, 1),
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            Assets.kLogin,
                            height: mediaQuery.size.width * 0.17,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
