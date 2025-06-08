import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../login/auth.dart';

class EditPoslovni {

  final client = http.Client();

  final editPoslovniUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/editposlovni');

  final accessToken = AuthService().accessToken;



  Future<void> editPoslovni(
      String name,
      String email,
      String phone,
      String address,
      String parkingTotal,
      String opis,
      BuildContext context,
      ) async {
    final body = {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'parkingTotal': parkingTotal,
      'opis': opis,
    };
    try {
      final getPlacesResponse = await client.post(
          editPoslovniUrl,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $accessToken"
          },
          body: jsonEncode(body)
      );
      if (getPlacesResponse.statusCode == 200) {
        final responseJson = jsonDecode(getPlacesResponse.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseJson['message'])),
        );

      }else {
        throw Exception("Server responded with status code ${getPlacesResponse.statusCode}");
      }
    } catch (e) {
      print("Get places error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return;
    }
  }

}