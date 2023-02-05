import 'dart:async';
import 'dart:io';

import 'package:bid_app/app/data/models/responses/login_response.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/main.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';

class BidProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://mearogateway.dpworld.com';

    httpClient.timeout = const Duration(minutes: 2);
    trustedCertificates = [
      TrustedCertificate(certificate.buffer.asUint8List())
    ];
    allowAutoSignedCert = false;
    httpClient.defaultContentType = 'application/json';

    httpClient.addRequestModifier<dynamic>((request) => updateHeaders(request));
  }

  FutureOr<Request<dynamic>> updateHeaders(Request<dynamic> request) {
    request.headers['Accept'] = 'application/json';

    final currentUser = Helpers.getCurrentUser();

    var accessToken = currentUser.tokenNumber;
    if (accessToken != null) {
      request.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";
    }

    request.headers['token'] = 'true'; // Required parameter by ower backend
    return request;
  }
}
