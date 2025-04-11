import 'dart:convert';

import 'package:findmyfood/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final client = http.Client();

  Future<UserModel?> login(String username, String password) async {
    final url = Uri.parse('https://nikola.com/login');  //this is where server link goes in
    final Map<String, dynamic> body = {
      'username': username,
      'password': password
    };

    print(body);
    try {
      final response =
      await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final UserModel user = UserModel.fromJson(result);

        SharedPreferences pref = await SharedPreferences.getInstance();

        pref.setString('token', user.token.toString());

        return user;
      } else {
        print("Request Failed with status code${response.statusCode}");
      }
    } catch (error) {
      print("$error");
    }
    return null;
  }
}