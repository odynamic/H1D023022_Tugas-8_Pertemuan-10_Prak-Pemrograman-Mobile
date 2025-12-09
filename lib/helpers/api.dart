import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  // POST request
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          if (token != null)
            HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // GET request
  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          if (token != null)
            HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // PUT request
  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          if (token != null)
            HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // DELETE request
  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          if (token != null)
            HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

dynamic _returnResponse(http.Response response) {
  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  switch (response.statusCode) {
    case 200:
    case 201:
      return jsonDecode(response.body);

    case 400:
      throw BadRequestException(response.body);
    case 401:
    case 403:
      throw UnauthorisedException(response.body);
    case 422:
      throw InvalidInputException(response.body);
    case 500:
    default:
      throw FetchDataException(
        'Server error: ${response.statusCode} | ${response.body}');
  }
}
}
