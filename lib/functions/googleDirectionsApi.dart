import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class EstimatedTime {
  getEstimatedTime(LatLng origin, LatLng destination) async {
    final String url = dotenv.get('googleApi');
    final String apiKey = dotenv.get('mapKey');
    final proxy = dotenv.get('placeAutoCompleteProxy');
    final String formattedOrigin = '${origin.latitude},${origin.longitude}';
    final String formattedDestination =
        '${destination.latitude},${destination.longitude}';
    try {
      http.Response response = await http.get(
        Uri.parse(
            '$proxy$url?origin=$formattedOrigin&destination=$formattedDestination&key=$apiKey'),
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic> route = jsonResponse['routes'];

      if (!route.isEmpty) {
        final String duration =
            jsonResponse['routes'][0]['legs'][0]['duration']['text'];

        return duration;
      } else {
        return null;
      }
    } catch (e) {
      print('Error in fetching Estimated Time : $e');
    }
  }
}
