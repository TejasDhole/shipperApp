import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '/controller/postLoadErrorController.dart';

// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> postLoadAPi(
    loadDate,
    postLoadId,
    loadingPoint,
    loadingPointCity,
    loadingPointState,
    loadingPoint2,
    loadingPointCity2,
    loadingPointState2,
    noOfTyre,
    productType,
    truckType,
    unloadingPoint,
    unloadingPointCity,
    unloadingPointState,
    unloadingPoint2,
    unloadingPointCity2,
    unloadingPointState2,
    weight,
    unitValue,
    rate,
    scheduleLoadingTime,
    scheduleLoadingDate,
    publishMethod,
    comment,
    loadTransporterList,
    biddingEndDate,
    biddingEndTime,
    loadingGeoFences,
    unloadingGeoFences,
    companyName) async {
  PostLoadErrorController postLoadErrorController =
      Get.put(PostLoadErrorController());
  try {
    Map data = {
      "loadDate": loadDate,
      "postLoadId": postLoadId,
      "loadingPoint": loadingPoint,
      "loadingPointCity": loadingPointCity,
      "loadingPointState": loadingPointState,
      "loadingPoint2": loadingPoint2,
      "loadingPointCity2": loadingPointCity2,
      "loadingPointState2": loadingPointState2,
      "noOfTyres": noOfTyre,
      "productType": productType,
      "truckType": truckType,
      "unloadingPoint": unloadingPoint,
      "unloadingPointCity": unloadingPointCity,
      "unloadingPointState": unloadingPointState,
      "unloadingPoint2": unloadingPoint2,
      "unloadingPointCity2": unloadingPointCity2,
      "unloadingPointState2": unloadingPointState2,
      "weight": weight,
      "unitValue": unitValue,
      "rate": rate,
      "loadingDate": scheduleLoadingDate,
      "loadingTime": scheduleLoadingTime,
      "publishMethod": publishMethod,
      "comment": comment,
      "transporterList": loadTransporterList,
      "biddingEndDate": biddingEndDate,
      "biddingEndTime": biddingEndTime,
      "loadingPointGeoId": loadingGeoFences,
      "unloadingPointGeoId": unloadingGeoFences,
      "companyName" : companyName
    };

    String body = json.encode(data);
    var jsonData;

    final String loadApiUrl = dotenv.get('loadApiUrl');

    final response = await http.post(Uri.parse(loadApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    jsonData = json.decode(response.body);


    if (response.statusCode == 201) {
      print("LOAD API Response-->$jsonData");
      if (jsonData["loadId"] != null) {
        String loadId = jsonData["loadId"];
        return loadId;
      } else {
        return null;
      }
    } else {
      print(response.statusCode);
      return null;
    }
  } catch (e) {
    postLoadErrorController.updatePostLoadError(e.toString());
    print(e.toString());
    return null;
  }
}
