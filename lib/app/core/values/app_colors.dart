import 'dart:ui';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  final Color textFieldUnfocused = Color(0xFFEFEFEF);
  final Color subtitlesTextColor = Color(0xFF868686);
  final Color cerulean = Color(0xFF1E1450);
  final Color ceruleanLight = Color(0xFF2F5496);
  final Color passwordFieldIconColor = Color(0xFFD1D1D1);
  final Color borderColor = Color(0xFFD8D8D8);
  final Color backgroundColor = Color(0xFFFEFEFE);
  final Color responsiblePeopleBg = Color(0xffF7F7F7);
  final Color loginBackground = Color(0xffFCFCFC);
  final Color hintTextColor = Color(0xFFBBBBBB);
  final Color textFieldFocused = Color(0xFF868686);
}
