import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestResources {

  final String _baseUrl = 'https://api.alquran.cloud/v1/';

  postData(data, url) async {
    var link = _baseUrl + url;
try{
   return await http.post(link,
        body: jsonEncode(data), headers: _setHeaders());
}
    catch(e){
    print(e);
   }
  }

  getResources(url) async {
    var link = _baseUrl + url;
try{
      return await http.get(link, headers: _setHeaders());
} catch(e) {
  print(e);
}
  }

  _setHeaders() =>
      {'content-type': 'application/json', 'Accept': 'application/json'};
}
