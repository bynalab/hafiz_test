import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class RequestResources {
  final String _baseUrl = 'https://api.alquran.cloud/v1/';

  postData(data, url) async {
    var link = _baseUrl + url;
    try {
      return await http.post(link,
          body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
    }
  }

  getResources(url) async {
    var link = _baseUrl + url;
    try {
      return await http.get(link, headers: _setHeaders());
    } catch (e) {
      print(e);
    }
  }

  _setHeaders() =>
      {'content-type': 'application/json', 'Accept': 'application/json'};

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
