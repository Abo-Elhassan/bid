import 'package:get/get.dart';

import '../modules/GDP/bindings/gdp_binding.dart';
import '../modules/GDP/views/gdp_view.dart';
import '../modules/GDPGR/bindings/gdpgr_binding.dart';
import '../modules/GDPGR/views/gdpgr_view.dart';
import '../modules/capacity/bindings/capacity_binding.dart';
import '../modules/capacity/views/capacity_view.dart';
import '../modules/developement/bindings/developement_binding.dart';
import '../modules/developement/views/developement_view.dart';
import '../modules/error/bindings/error_binding.dart';
import '../modules/error/views/error_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/nature_of_involvement/bindings/nature_of_involvement_binding.dart';
import '../modules/nature_of_involvement/views/nature_of_involvement_view.dart';
import '../modules/population/bindings/population_binding.dart';
import '../modules/population/views/population_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/volume/bindings/volume_binding.dart';
import '../modules/volume/views/volume_view.dart';
import '../modules/weather_forecast/bindings/weather_forecast_binding.dart';
import '../modules/weather_forecast/views/weather_forecast_view.dart';
import '../modules/weather_forecast/views/weather_forecast_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_FORECAST,
      page: () => const WeatherForecastView(),
      binding: WeatherForecastBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_FORECAST_DETAILS,
      page: () => const WeatherForecastDetailsView(),
      binding: WeatherForecastBinding(),
    ),
    GetPage(
      name: _Paths.GDP,
      page: () => const GdpView(),
      binding: GdpBinding(),
    ),
    GetPage(
      name: _Paths.GDPGR,
      page: () => const GdpgrView(),
      binding: GdpgrBinding(),
    ),
    GetPage(
      name: _Paths.POPULATION,
      page: () => const PopulationView(),
      binding: PopulationBinding(),
    ),
    GetPage(
      name: _Paths.VOLUME,
      page: () => const VolumeView(),
      binding: VolumeBinding(),
    ),
    GetPage(
      name: _Paths.CAPACITY,
      page: () => const CapacityView(),
      binding: CapacityBinding(),
    ),
    GetPage(
      name: _Paths.DEVELOPEMENT,
      page: () => const DevelopementView(),
      binding: DevelopementBinding(),
    ),
    GetPage(
      name: _Paths.NATURE_OF_INVOLVEMENT,
      page: () => const NatureOfInvolvementView(),
      binding: NatureOfInvolvementBinding(),
    ),
    GetPage(
      name: _Paths.ERROR,
      page: () => const ErrorView(),
      binding: ErrorBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
