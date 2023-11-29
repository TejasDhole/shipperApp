import 'dart:convert';

import 'package:get/get.dart';
import '/controller/shipperIdController.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/models/BookingModel.dart';

class BookingApiCalls {
  //shipperIdController will be used as postId in Transporter App
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  //BookingApiUrl
  // final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');
  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  //to hold list of dataModels retrieved from Api
  List<BookingModel> modelList = [];

  //GET ------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdOnGoing() async {
    modelList = [];
    //print('getDataByPostLoadIdOnGoing in');
    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$bookingApiUrl?postLoadId=${shipperIdController.ownerShipperId.value}&completed=false&cancel=false&pageNo=$i'));

      var jsonData = json.decode(response.body);

      if (jsonData.isEmpty) {
        break;
      }

      for (var json in jsonData) {
        BookingModel bookingModel = BookingModel(truckId: []);
        bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : "NA";
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.driverName = json['driverName'];
        bookingModel.driverPhoneNum = json['driverPhoneNum'];
        bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : "NA";
        bookingModel.deviceId = int.tryParse(json['deviceId']);
        bookingModel.loadingPointCity = json['loadingPointCity'];
        bookingModel.unloadingPointCity = json['unloadingPointCity'];
        modelList.add(bookingModel);
      }
    }
    return modelList;
  }

  //----------------------------------------------------------------------------
  Future<List<BookingModel>> getDataByPostLoadIdDelivered() async {
    modelList = [];
    for (int i = 0;; i++) {
      http.Response response = await http.get(Uri.parse(
          '$bookingApiUrl?postLoadId=${shipperIdController.shipperId.value}&completed=true&cancel=false&pageNo=$i'));
      var jsonData = json.decode(response.body);

      if (jsonData.isEmpty) {
        break;
      }
      for (var json in jsonData) {
        BookingModel bookingModel = BookingModel(truckId: []);
        bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : "NA";
        bookingModel.bookingId = json['bookingId'];
        bookingModel.postLoadId = json['postLoadId'];
        bookingModel.loadId = json['loadId'];
        bookingModel.transporterId = json['transporterId'];
        bookingModel.truckId = json['truckId'];
        bookingModel.cancel = json['cancel'];
        bookingModel.completed = json['completed'];
        bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : "NA";
        bookingModel.rate =
            json['rate'] != null ? json['rate'].toString() : 'NA';
        bookingModel.unitValue = json['unitValue'];
      }
    }
    return modelList;
  }

  //----------------------------------------------------------------------------
}
