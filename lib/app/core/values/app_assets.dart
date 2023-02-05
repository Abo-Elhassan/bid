const String _kAssets = "assets/";
const String _kImages = "${_kAssets}images/";
const String _kIcons = "${_kAssets}icons/";

class Assets {
  const Assets._();

  static String weatherIcon(int iconNo) {
    return "$_kIcons$iconNo.png";
  }

  static const String kWorldMap = "${_kAssets}world-map.json";
  static const String kCertificate =
      "${_kAssets}certificates/mearogateway.dpworld.pem";
  static const String kMaxTemperature = "${_kIcons}day.png";
  static const String kMinTemperature = "${_kIcons}night.png";
  static const String kWindDirection = "${_kIcons}wind-direction.png";
  static const String kWindSpeed = "${_kIcons}wind-speed.png";
  static const String kHumidity = "${_kIcons}humidity.png";
  static const String kRainProbability = "${_kIcons}rain-probability.png";
  static const String kSplashBackground = "${_kImages}splash_background.gif";

  static const String kBackground = "${_kImages}background.png";
  static const String kEarthLines = "${_kImages}earth_icon.png";
  static const String kLogin = "${_kImages}login.png";
  static const String kStart = "${_kImages}start.png";
  static const String kDpLogo = "${_kImages}dp_logo.png";
}
