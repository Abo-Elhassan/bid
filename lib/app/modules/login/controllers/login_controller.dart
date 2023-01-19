import 'package:bid_app/shared/helpers.dart';
import 'package:bid_app/app/data/models/requests/filter_data_request.dart';
import 'package:bid_app/app/data/models/requests/login_request.dart';
import 'package:bid_app/app/data/providers/login_provider.dart';
import 'package:bid_app/app/data/providers/widget_data_provider.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isloading = false.obs;
  Widget buildTextInput(
    TextEditingController inputController,
    String label,
    String placeHolder,
    TextInputType textInputType,
  ) {
    final themeData = Theme.of(Get.context!);
    final mediaQuery = MediaQuery.of(Get.context!);
    return TextFormField(
      obscureText: label == 'Password' ? true : false,
      keyboardType: textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.bottom,
      cursorColor: Colors.black,
      style: const TextStyle(
        height: 2,
        color: Colors.black,
        fontFamily: 'Pilat Demi',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
          errorMaxLines: 2,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(58, 58, 66, 1),
            fontFamily: 'Pilat Demi',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          labelStyle: const TextStyle(
            color: Color.fromRGBO(15, 15, 25, 1),
            fontFamily: 'Pilat Demi',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color.fromRGBO(110, 110, 114, 1),
            fontFamily: 'Pilat Demi',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.only(bottom: 10),
          labelText: label,
          hintText: placeHolder),
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
            await Get.offNamed(Routes.HOME);
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

      await Helpers.dialog(Icons.error, Colors.red, 'An Error Occured!!');
    }
  }
}
