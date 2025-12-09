import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/login.dart';

class LoginBloc {
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    String apiUrl = ApiUrl.login;

    // Jangan jsonEncode
    var body = {
      "email": email,
      "password": password,
    };

    // Api().post() SUDAH decode JSON → return Map
    var jsonObj = await Api().post(apiUrl, body);

    return Login.fromJson(jsonObj);
  }
}
