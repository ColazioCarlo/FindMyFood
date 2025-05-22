import 'dart:convert';
import 'dart:ffi';
import 'package:find_my_food/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'login/login.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance; //konstruktor da ne kreira novi AuthService svaki put kad se poziva
  AuthService._internal(); //kreira AuthService

  final client = http.Client();

  String? _username;
  String? get username => _username; //getter za _username

  String? accessToken;
  String? refreshToken;

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
        accessToken = loginData['access_token'];
        refreshToken = loginData['refresh_token'];


        final protectedResponse = await client.get( //get request za username
          protectedUrl,
          headers: {'Content-Type': 'application/json',
            "Authorization": "Bearer $accessToken"   //bearer token
          },

        );

        String protectedMessage = "Access failed";

        if (protectedResponse.statusCode == 200) { //ako je response ok -> izvadi username iz messagea
          final responseJson = jsonDecode(protectedResponse.body);
          final msg = responseJson['message'] as String;
          final username = msg.split(' ').last;

          _username = username;
          protectedMessage = msg;
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

  Future<void> register(
      String username,
      String password,
      BuildContext context
      ) async { //omogucuje asinkrono programiranje
    final registerUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/register');

    final body = {
      'username': username,
      'password': password,
    };

    try {
      final registerResponse = await client.post( //salje user i pass za registriranje
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (registerResponse.statusCode == 201) { //provjerava ako je register ok
        final responseJson = jsonDecode(registerResponse.body);


        ScaffoldMessenger.of(context).showSnackBar( //prikaze poruku od registracije
          SnackBar(content: Text(responseJson['message'])),


        );

        Navigator.pushNamed(context, '/home');   //ako je registracija uspjesna ide na home screen


      } else {
        print("Register failed: ${registerResponse.statusCode}");
        final responseJson = jsonDecode(registerResponse.body);
        String error = responseJson['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar( //prikaze error ako ga ima
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> registerposlovni(
      String username,
      String password,
      String name,
      String email,
      String phone,
      String address,
      Int8 parking,
      String opis,
      BuildContext context,
      ) async { //omogucuje asinkrono programiranje
    final registerposlovniUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/registerposlovni'); //ovisi o backendu

    final body = {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'parking': parking,
      'opis': opis,
    };

    try {
      final registerResponse = await client.post( //salje user i pass za registriranje
        registerposlovniUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (registerResponse.statusCode == 201) { //provjerava ako je register ok
        final responseJson = jsonDecode(registerResponse.body);


        ScaffoldMessenger.of(context).showSnackBar( //prikaze poruku od registracije
          SnackBar(content: Text(responseJson['message'])),


        );

        Navigator.pushNamed(context, '/home');

      } else {
        print("Register failed: ${registerResponse.statusCode}");
        final responseJson = jsonDecode(registerResponse.body);
        String error = responseJson['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar( //prikaze error ako ga ima
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

    //access token ima 30min? expire time, ovako ga refresha
  Future<void> refreshAccessToken() async {

    final refreshUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/refresh');

    if (!JwtDecoder.isExpired(accessToken!)) {  //ako je token valjani ne radi nista
      print("token je vazeci");
      return;
    }

    try {
      final response = await http.post(   //ako je nevazeci onda nabavlja novi
        refreshUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        accessToken = data['access_token'];
      } else {
        print('Token refresh failed: ${response.statusCode}');
        return;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return;
    }
  }
}