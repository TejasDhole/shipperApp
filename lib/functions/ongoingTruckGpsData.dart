import 'package:get_storage/get_storage.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getDeviceData.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getPositionByDeviceId.dart';
import 'package:shipper_app/functions/ongoingTrackUtils/getTraccarSummaryByDeviceId.dart';
import 'package:shipper_app/models/gpsDataModel.dart';
import 'package:shipper_app/models/onGoingCardModel.dart';

class OngoingTruckGpsData {
  GpsDataModel? gpsData;
  var deviceList;
  var gpsDataList;
  List gpsList = [];

  String? from;
  String? to;
  String? totalDistance;
  var imei;
  final OngoingCardModel loadAllDataModel;

  OngoingTruckGpsData(this.loadAllDataModel);

  Future<List> getTruckGpsDetails() async{

    DateTime yesterday = DateTime.now()
        .subtract(const Duration(days: 1, hours: 5, minutes: 30)); //from param
    from = yesterday.toIso8601String();

    DateTime now =
    DateTime.now().subtract(const Duration(hours: 5, minutes: 30)); //to param
    to = now.toIso8601String();

    // getMyTruckPosition();
    var devices =
        await getDeviceByDeviceId(loadAllDataModel.deviceId.toString());

    var gpsDataAll =
        await getPositionByDeviceId(loadAllDataModel.deviceId.toString());

    deviceList = [];

    if (devices != null) {
      for (var device in devices) {
        deviceList.add(device);
      }
    }

    gpsList = List.filled(devices.length, null, growable: true);

    //for loop will iterate and change the gpsList contents
    for (int i = 0; i < gpsDataAll.length; i++) {
      // getGPSData(gpsDataAll[i], i);
      gpsList.removeAt(i);

      gpsList.insert(i, gpsDataAll[i]);
    }

    gpsDataList = gpsList;

    var gpsRoute1 = await getTraccarSummaryByDeviceId(
        deviceId: loadAllDataModel.deviceId, from: from, to: to);
    totalDistance = (gpsRoute1[0].distance! / 1000).toStringAsFixed(2);

    return [deviceList,gpsDataList,totalDistance,imei];

  }
}

