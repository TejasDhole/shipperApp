import 'package:flutter/material.dart';
import 'package:shipper_app/functions/shipperApis/shipperApiCalls.dart';
import 'package:shipper_app/functions/transporterApis/transporterApiCalls.dart';
import 'package:shipper_app/models/transporterModel.dart';
import '/functions/truckApis/truckApiCalls.dart';
import '/models/deliveredCardModel.dart';
import '/models/driverModel.dart';
import '/models/onGoingCardModel.dart';
import '/models/shipperModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

Future<DeliveredCardModel> loadAllDeliveredData(bookingModel) async {
  final LoadApiCalls loadApiCalls = LoadApiCalls();

  final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  //fetch load details from load api
  Map loadData = await loadApiCalls.getDataByLoadId(bookingModel.loadId);

  //fetch details of transporter using transporter id.
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);

  //place all the data into DeliveredCardModel and displaying the completed loads.
  DeliveredCardModel loadALLDataModel = DeliveredCardModel();
  loadALLDataModel.loadId = bookingModel.loadId;
  loadALLDataModel.bookingDate = bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.deviceId = bookingModel.deviceId;
  loadALLDataModel.loadingPointCity = loadData['loadingPointCity'];
  loadALLDataModel.unloadingPointCity = loadData['unloadingPointCity'];
  loadALLDataModel.companyName = transporterModel.companyName;
  loadALLDataModel.transporterPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.transporterLocation = transporterModel.transporterLocation;
  loadALLDataModel.transporterName = transporterModel.transporterName;
  loadALLDataModel.companyApproved = transporterModel.companyApproved;
  loadALLDataModel.truckNo = bookingModel.truckId[0];
  loadALLDataModel.truckType = loadData['truckType'];
  loadALLDataModel.driverName = bookingModel.driverName;
  loadALLDataModel.driverPhoneNum = bookingModel.driverPhoneNum;
  loadALLDataModel.rate = bookingModel.rate.toString();
  loadALLDataModel.unitValue = bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = loadData['noOfTrucks'];
  loadALLDataModel.productType = loadData['productType'];

  return loadALLDataModel;
}
