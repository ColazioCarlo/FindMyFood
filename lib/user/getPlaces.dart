import 'dart:convert';
import 'package:find_my_food/login/auth.dart';
import 'package:find_my_food/place.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class GetPlaces {

  final client = http.Client();

  final getPlacesUrl = Uri.parse('http://kthreljin.dyndns.biz:8080/getplaces');

  final accessToken = AuthService().accessToken;


  Future<List<PlaceModel>> getPlaces(
      String longitude,
      String latitude,
      String? radius,
      String? placeType,
      BuildContext context,
      ) async {
    final body = {
      'longitude': longitude,
      'latitude': latitude,
      'radius': radius,
      'placeType': placeType,
    };

    try {
      final getPlacesResponse = await client.post(
          getPlacesUrl,
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $accessToken"   //bearer token
          },
          body: jsonEncode(body)
      );
      if (getPlacesResponse.statusCode == 200) {
        final responseJson = jsonDecode(getPlacesResponse.body);

        final List<PlaceModel> places = (responseJson as List)
            .map((place) => PlaceModel.fromJson(place))
            .toList();

        return places;
      }else {
        throw Exception("Server responded with status code ${getPlacesResponse.statusCode}");
      }
    } catch (e) {
        print("Get places error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
        return []; // Return empty list instead of null
    }
  }
}