import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/functions/placeAutoFillUtils/autoFillGoogle.dart';

class EstimatedTime {
  getEstimatedTime(LatLng origin, LatLng destination) async {
    //final String url = dotenv.get('googleApi');
    final String apiKey = dotenv.get('mapKey');
     final proxy = dotenv.get('placeAutoCompleteProxy');
    final String formattedOrigin = '${origin.latitude},${origin.longitude}';
    final String formattedDestination =
        '${destination.latitude},${destination.longitude}';
    try {
      http.Response response = await http.get(
        Uri.parse(
            '${proxy}https://maps.googleapis.com/maps/api/directions/json?origin=$formattedOrigin&destination=$formattedDestination&key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final List<dynamic> routes = jsonResponse['routes'];

        if (routes.isNotEmpty) {
          final String duration =
              jsonResponse['routes'][0]['legs'][0]['duration']['text'];
          return duration;
        } else {
          return null;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in fetching Estimated Time: $e');
      return null;
    }
  }
}
