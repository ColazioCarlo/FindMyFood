import 'dart:convert';
import 'package:find_my_food/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance; //konstruktor da ne kreira novi AuthService svaki put kad se poziva
  AuthService._internal(); //kreira AuthService

  final client = http.Client();

  String? _username;
  String? get username => _username; //getter za _username

  Future<UserModel?> login( //model usera kad ga budemo dobili
      String username,
      String password,
      BuildContext context,
      ) async { //omogucuje asinkrono programiranje
    final loginUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/login'); //link od dba
    final protectedUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/protected');

    final body = {
      'username': username,
      'password': password,
    };

    try {
      final loginResponse = await client.post( //salje user i pass za autentifikaciju
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (loginResponse.statusCode == 200) { //provjerava ako je login ok i daje token
        final loginData = jsonDecode(loginResponse.body);
        final token = loginData['token'];


        final protectedResponse = await client.get( //get request za username
          protectedUrl,
          headers: {'Content-Type': 'application/json',
            'token': token,
          },

        );

        String protectedMessage = "Access failed";


        if (protectedResponse.statusCode == 200) { //ako je response ok -> izvadi username iz messagea
          final responseJson = jsonDecode(protectedResponse.body);
          final msg = responseJson['message'] as String;
          final username = msg.split(' ').last;

          _username = username;
          protectedMessage = "Logged in as $username";
        }


        ScaffoldMessenger.of(context).showSnackBar( //prikaze poruku od logina
          SnackBar(content: Text(protectedMessage)),
        );

        return UserModel.fromJson(loginData);
      } else {
        print("Login failed: ${loginResponse.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar( //prikaze error ako ga ima
        SnackBar(content: Text("Error: $e")),
      );
    }
    return null;
  }
}