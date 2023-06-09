import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/login_request.dart';
import 'package:bid_app/app/data/providers/login_provider.dart';
import 'package:bid_app/app/data/providers/dashboard_provider.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isloading = false.obs;
  RxBool _passwordVisible = false.obs;
  Widget buildTextInput(
    TextEditingController inputController,
    String label,
    String placeHolder,
    TextInputType textInputType,
  ) {
    final themeData = Theme.of(Get.context!);
    final mediaQuery = MediaQuery.of(Get.context!);
    return TextFormField(
      obscureText: label != 'Password'
          ? false
          : _passwordVisible.isTrue
              ? false
              : true,
      keyboardType: textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.bottom,
      cursorColor: Colors.black,
      style: TextStyle(
        height: 2,
        color: Colors.black,
        fontFamily: 'Pilat Demi',
        fontSize: mediaQuery.size.width * 0.04,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintStyle: TextStyle(
          color: Color.fromRGBO(58, 58, 66, 1),
          fontFamily: 'Pilat Demi',
          fontWeight: FontWeight.bold,
          fontSize: mediaQuery.size.width * 0.04,
        ),
        labelStyle: TextStyle(
          color: Color.fromRGBO(15, 15, 25, 1),
          fontFamily: 'Pilat Demi',
          fontSize: mediaQuery.size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelStyle: TextStyle(
          color: Color.fromRGBO(110, 110, 114, 1),
          fontFamily: 'Pilat Demi',
          fontSize: mediaQuery.size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: const EdgeInsets.only(bottom: 10),
        labelText: label,
        hintText: placeHolder,
        suffixIcon: label == 'Password'
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                  size: mediaQuery.size.width * 0.07,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable

                  _passwordVisible.value = !_passwordVisible.value;
                },
              )
            : const SizedBox(),
      ),
      controller: inputController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  void saveForm(String username, String password) async {
    try {
      final isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      } else {
        formKey.currentState?.save();

        isloading.value = true;

        if (await Helpers.checkConnectivity()) {
          var credentials = LoginRequest(
              username: usernameController.text.trim(),
              password: passwordController.text.trim());
          final resopnse = await Get.find<LoginProvider>().login(credentials);

          usernameController.text = "";
          passwordController.text = "";
          if (resopnse.statusCode == 200) {
            switch (Helpers.getCurrentUser().roleType) {
              case 1:
                await Get.offNamed(Routes.HOME);
                break;
              case 2:
                await Get.offNamed(Routes.HOME);
                break;
              case 3:
                await Get.offNamed(Routes.WEATHER_FORECAST);
                break;
              default:
            }
          } else {
            await Helpers.dialog(
                Icons.error, Colors.red, 'Incorrect username or password');
          }
        } else {
          await Helpers.dialog(Icons.wifi_off_outlined, Colors.red,
              'Please check Your Netowork Connection');
        }
        isloading.value = false;
      }
    } catch (error) {
      isloading.value = false;

      await Helpers.dialog(Icons.error, Colors.red, "Internal Error Occured");
    }
  }
}
