import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkServices {
  final String _baseUrl = 'https://api.alquran.cloud/v1/';

  Future get(url) async {
    var link = Uri.parse(_baseUrl + url);

    try {
      return await http.get(link, headers: _setHeaders());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _setHeaders() {
    return {
      'content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
    return false;
  }
}
