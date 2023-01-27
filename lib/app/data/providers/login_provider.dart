import 'package:bid_app/app/data/models/requests/login_request.dart';
import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://mearogateway.dpworld.com/Auth';

    httpClient.timeout = const Duration(minutes: 2);
    trustedCertificates = [
      TrustedCertificate(certificate.buffer.asUint8List())
    ];
    allowAutoSignedCert = false;
    httpClient.defaultContentType = 'application/json';

    httpClient.defaultDecoder = (map) {
      return LoginResponse.fromJson(map);
    };
  }

  Future<LoginResponse> login(LoginRequest credentials) async {
    try {
      var body = credentials.toJson();
      final response = await post('/GetToken', body);

      final localStorage = GetStorage();
      localStorage.write('username', credentials.username);
      late LoginResponse currentUser = response.body;
      currentUser.username = credentials.username.toString().toUpperCase();
      localStorage.write('loginResponse', currentUser.toJson());

      return currentUser;
    } catch (e) {
      rethrow;
    }
  }
}
