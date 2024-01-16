import 'package:flutter/material.dart';
import 'package:shipper_app/functions/shipperApis/shipperApiCalls.dart';
import 'package:shipper_app/functions/transporterApis/transporterApiCalls.dart';
import 'package:shipper_app/models/transporterModel.dart';
import '/functions/truckApis/truckApiCalls.dart';
import '/models/BookingModel.dart';
import '/models/driverModel.dart';
import '/models/onGoingCardModel.dart';
import '/models/shipperModel.dart';
import 'driverApiCalls.dart';
import 'loadApiCalls.dart';

//TODO:later on ,put these variables inside the function
LoadApiCalls loadApiCalls = LoadApiCalls();

ShipperApiCalls shipperApiCalls = ShipperApiCalls();

TruckApiCalls truckApiCalls = TruckApiCalls();

DriverApiCalls driverApiCalls = DriverApiCalls();

Future<OngoingCardModel?> loadAllOngoingData(BookingModel bookingModel) async {

  final TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  //fetch details of transporter using transporter id.
  TransporterModel transporterModel = await transporterApiCalls
      .getDataByTransporterId(bookingModel.transporterId);


  OngoingCardModel loadALLDataModel = OngoingCardModel();
  loadALLDataModel.loadId = bookingModel.loadId;
  loadALLDataModel.bookingDate = bookingModel.bookingDate;
  loadALLDataModel.bookingId = bookingModel.bookingId;
  loadALLDataModel.completedDate = bookingModel.completedDate;
  loadALLDataModel.deviceId = bookingModel.deviceId;
  loadALLDataModel.loadingPointCity = bookingModel.loadingPointCity;
  loadALLDataModel.unloadingPointCity = bookingModel.unloadingPointCity;
  loadALLDataModel.companyName = transporterModel.companyName;
  loadALLDataModel.shipperPhoneNum = transporterModel.transporterPhoneNum;
  loadALLDataModel.shipperLocation = transporterModel.transporterLocation;
  loadALLDataModel.shipperName = transporterModel.transporterName;
  loadALLDataModel.companyApproved = transporterModel.companyApproved;
  loadALLDataModel.truckNo = bookingModel.truckNo;
  loadALLDataModel.truckType = 'NA';
  loadALLDataModel.imei = 'NA';
  loadALLDataModel.driverName = bookingModel.driverName;
  loadALLDataModel.driverPhoneNum = bookingModel.driverPhoneNum;
  loadALLDataModel.rate = bookingModel.rate.toString();
  loadALLDataModel.unitValue = bookingModel.unitValue;
  loadALLDataModel.noOfTrucks = 'NA';
  loadALLDataModel.productType = 'NA';

  return loadALLDataModel;
}
