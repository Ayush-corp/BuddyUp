import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:5000';

class BaseClient {
  var client = http.Client();

  //GET
  Future<dynamic> get(String api) async {

    var url = Uri.parse(baseUrl + api);
    print(url);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    print(url);
    print(payload);
    var headers = {
    //   'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'Accept' : '*/*',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Connection' : 'keep-alive'
    //   'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.post(url, body: payload, headers: headers);
    // var response = await client.post(url, body: payload);
    print('response');
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  ///PUT Request
  Future<dynamic> put(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.put(url, body: payload, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  Future<dynamic> delete(String api) async {
    var url = Uri.parse(baseUrl + api);
    var headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.delete(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }
}