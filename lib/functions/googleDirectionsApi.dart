import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class EstimatedTime {
  getEstimatedTime(LatLng origin, LatLng destination) async {
    //final String url = dotenv.get('googleApi');
    final String apiKey = dotenv.get('mapKey');
    // final proxy = dotenv.get('placeAutoCompleteProxy');
    final String formattedOrigin = '${origin.latitude},${origin.longitude}';
    print("origin: $formattedOrigin");
    final String formattedDestination =
        '${destination.latitude},${destination.longitude}';
    print("destination : $formattedDestination");
    try {
      http.Response response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/directions/json?origin=$formattedOrigin&destination=$formattedDestination&key=$apiKey'),
      );
      print('Response status code: ${response.statusCode}');
      print('response : $response.body');

//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       print("json : $jsonResponse");
//       final List<dynamic> route = jsonResponse['routes'];
// print(route);
//       if (!route.isEmpty) {
//         final String duration =
//             jsonResponse['routes'][0]['legs'][0]['duration']['text'];
//         print(duration);
//         return duration;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error in fetching Estimated Time : $e');
//       return null;
//     }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Decoded JSON: $jsonResponse');

        final List<dynamic> routes = jsonResponse['routes'];

        if (routes.isNotEmpty) {
          final String duration =
              jsonResponse['routes'][0]['legs'][0]['duration']['text'];
          print('Duration: $duration');
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
