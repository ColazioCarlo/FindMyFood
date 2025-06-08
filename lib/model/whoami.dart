import 'dart:convert';

import 'package:find_my_food/model/place.dart';
import 'package:http/http.dart' as http;

import '../login/auth.dart';

class WhoAmI {

  final client = http.Client();

  final whoamiUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/whoami');
  final accessToken = AuthService().accessToken;

  Future<PlaceModel> whoami() async {
    try {
      final editResponse = await client.get(
        whoamiUrl,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );

      if (editResponse.statusCode == 200) {
        final responseJson = jsonDecode(editResponse.body);
        final PlaceModel place = PlaceModel.fromJson(responseJson);
        return place;
      }
      else {
        throw Exception("Server responded with status code ${editResponse.statusCode}");
      }
    }
    catch (e) {
      throw Exception("Error: $e");
    }
  }
}