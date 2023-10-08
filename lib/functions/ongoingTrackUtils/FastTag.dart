import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shipper_app/models/vehicleDetails.dart';
import 'package:xml/xml.dart';

class checkFastTag {
  Future<List<dynamic>> getVehicleLocation(String vehicle) async {
    final String url = dotenv.get("fastTag");

    final Map<String, dynamic> params = {"vehiclenumber": vehicle};

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(params),
    );

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      debugPrint(response.body);
      final List<dynamic> txnList = jsonResponse['response'][0]['response']
          ['vehicle']['vehltxnList']['txn'];

      final reversedList = List.from(txnList.reversed);
      return reversedList.cast<Map<String, dynamic>>();
    } else {
      debugPrint('API Error: ${response.statusCode} - ${response.body}');
      throw Exception("No auth token is there, some error in the API");
    }
  }

  Future<VehicleDetails> fetchVehicleDetails(String vehicleNumber) async {
    final String vahanApiUrl = dotenv.get('vahanUrl');

    // Create the request body
    final requestBody = jsonEncode({
      "vehiclenumber": vehicleNumber,
    });

    try {
      final response = await http.post(
        Uri.parse(vahanApiUrl),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        debugPrint('API Response: $jsonResponse');

        // Check if the "response" key exists in the JSON response
        if (jsonResponse.containsKey('response') &&
            jsonResponse['response'] is List) {
          final responseList = jsonResponse['response'];

          if (responseList.isNotEmpty) {
            // Take the first response from the list
            final firstResponse = responseList[0];

            // Extract the XML content
            if (firstResponse.containsKey('response')) {
              final xmlResponse = firstResponse['response'];

              // Parse the XML content
              final documents = XmlDocument.parse(xmlResponse);
              final root = documents.rootElement;

              if (root.name.local == 'VehicleDetails') {
                final vehicleDetails = VehicleDetails.fromXml(root);
                return vehicleDetails;
              }
            }
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load vehicle details');
      }
    } catch (e) {
      debugPrint('Error fetching vehicle details: $e');
      throw e;
    }
  }
}
