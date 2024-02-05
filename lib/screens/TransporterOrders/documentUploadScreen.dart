import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/buttons/editDriverDetail.dart';
import 'package:shipper_app/Widgets/buttons/sendConsentButton.dart';
import 'package:shipper_app/Widgets/buttons/trackButton.dart';
import 'package:shipper_app/Widgets/showSnackBarTop.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/LrPdfGenerator.dart';
import 'package:shipper_app/functions/loadOnGoingData.dart';
import 'package:shipper_app/functions/operatorInfo.dart';
import 'package:shipper_app/functions/truckApis/consentStatusApi.dart';
import 'package:shipper_app/models/onGoingCardModel.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/FastTagScreen.dart';
import 'package:shipper_app/screens/vehicleDetailsScreen.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/providerClass/providerData.dart';
import '/screens/TransporterOrders/docInputEWBill.dart';
import '/screens/TransporterOrders/docInputPod.dart';
import '/screens/TransporterOrders/docInputWgtReceipt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'docInputLr.dart';
import '/functions/documentApi/getDocName.dart';
import '/functions/documentApi/getDocumentApiCall.dart';
import '/functions/documentApi/postDocumentApiCall.dart';
import '/functions/documentApi/putDocumentApiCall.dart';

class documentUploadScreen extends StatefulWidget {
  String? bookingId;
  String? bookingDate;
  String? truckNo;
  String? transporterName;
  String? transporterPhoneNum;
  String? driverName;
  String? driverPhoneNum;
  String? loadingPoint;
  String? loadingPointCity;
  String? unloadingPoint;
  String? unloadingPointCity;
  var gpsDataList;
  String? totalDistance;
  var device;
  String? productType;
  String? truckType;
  String? unitValue;
  final OngoingCardModel? loadAllDataModel;

  documentUploadScreen({
    Key? key,
    this.bookingId,
    this.bookingDate,
    this.truckNo,
    this.transporterName,
    this.transporterPhoneNum,
    this.driverName,
    this.driverPhoneNum,
    this.unloadingPoint,
    this.loadingPoint,
    this.loadingPointCity,
    this.unloadingPointCity,
    this.gpsDataList,
    this.totalDistance,
    this.device,
    this.productType,
    this.truckType,
    this.unitValue,
    this.loadAllDataModel,
  }) : super(key: key);

  @override
  _documentUploadScreenState createState() => _documentUploadScreenState();
}

class _documentUploadScreenState extends State<documentUploadScreen>
    with TickerProviderStateMixin {
  bool progressBar = false;

  String status = 'Pending'; // Default status
  String? selectedOperator;
  List<String> operatorOptions = [
    'Airtel',
    'Vodafone',
    'Jio',
  ];
  final StatusAPI statusAPI = StatusAPI();

  Map? loadData;

  @override
  void initState() {
    super.initState();
    fetchDataFromLoadApi();
    fetchConsent();
    loadOperatorInfo(widget.driverPhoneNum, updateSelectedOperator);
    Permission.camera.request();
  }

  fetchDataFromLoadApi() async {
    Map ongoingloadData =
        await loadApiCalls.getDataByLoadId(widget.loadAllDataModel!.loadId!);
    setState(() {
      loadData = ongoingloadData;
    });
  }

  void updateSelectedOperator(String newOperator) {
    setState(() {
      selectedOperator = newOperator;
    });
  }

  Future<void> fetchConsent() async {
    final responseStatus = await statusAPI.getStatus(widget.driverPhoneNum!);

    setState(() {
      status = responseStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    Get.put(ShipperIdController());
    var providerData = Provider.of<ProviderData>(context);

    late Map
        datanew; // this map will contain the data to be posted using the post document api.
    datanew = {
      "entityId": widget.bookingId.toString(),
      "documents": [{}],
    };
    late Map dataput;

    //This function is used to fetch the operator info select it by default from the dropdown

    // function to call the post or put api functions according to the need to upload the documents.
    uploadDocumentApiCall() async {
      var response = await postDocumentApiCall(datanew);
      if (response == "put") {
        dataput = {"documents": datanew["documents"]};

        response =
            await putDocumentApiCall(dataput, widget.bookingId.toString());
      }
      if (response == "successful") {
        // after uploading the document successfully we null the provider data of the documents to stop displaying the document upload screen.
        setState(() {
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
          progressBar = false;
        });
      }
      // return response;
    }

    var jsonresponse;
    var docLinks = [];
    var availDocs = [];

    mapAvaildataPod(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.PodPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNamePod(int i) async {
      // for assigning the document name according the available document name.
      if (i == 0) {
        await mapAvaildataPod(i, "PodPhoto1");
      } else if (i == 1) {
        await mapAvaildataPod(i, "PodPhoto2");
      } else if (i == 2) {
        await mapAvaildataPod(i, "PodPhoto3");
      } else if (i == 3) {
        await mapAvaildataPod(i, "PodPhoto4");
      }
    }

    uploadFirstPod() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "PodPhoto1", "data": providerData.PodPhoto64}
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckPod() async {
      // to check already uploaded pod documents .
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "P");
      setState(() {
        docLinks = docLinks;
      });

      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "P");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNamePod(availDocs[0]);
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
        }
      } else {
        await uploadFirstPod();
      }
    }

    mapAvaildataLr(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.LrPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameLr(int i) async {
      if (i == 0) {
        await mapAvaildataLr(i, "LrPhoto1");
      } else if (i == 1) {
        await mapAvaildataLr(i, "LrPhoto2");
      } else if (i == 2) {
        await mapAvaildataLr(i, "LrPhoto3");
      } else if (i == 3) {
        await mapAvaildataLr(i, "LrPhoto4");
      }
    }

    uploadFirstLr() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "LrPhoto1", "data": providerData.LrPhoto64}
        ],
      };
      // providerData.Lr = false;
      await uploadDocumentApiCall();
    }

    uploadedCheckLr() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "L");
      setState(() {
        docLinks = docLinks;
      });

      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "L");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNameLr(availDocs[0]);
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
        }
      } else {
        await uploadFirstLr();
      }
    }

    mapAvaildataEwayBill(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.EwayBillPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameEwayBill(int i) async {
      if (i == 0) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto1");
      } else if (i == 1) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto2");
      } else if (i == 2) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto3");
      } else if (i == 3) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto4");
      }
    }

    uploadFirstEwayBill() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "EwayBillPhoto1",
            "data": providerData.EwayBillPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckEwayBill() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "E");
      setState(() {
        docLinks = docLinks;
      });
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "E");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNameEwayBill(availDocs[0]);
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
        }
      } else {
        await uploadFirstEwayBill();
      }
    }

    mapAvaildataWeightReceipt(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.WeightReceiptPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameWeightReceipt(int i) async {
      if (i == 0) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto1");
      } else if (i == 1) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto2");
      } else if (i == 2) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto3");
      } else if (i == 3) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto4");
      }
    }

    uploadFirstWeightReceipt() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "WeightReceiptPhoto1",
            "data": providerData.WeightReceiptPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    String wrapWords(String input, int maxChars) {
      List<String> words = input.split(' ');
      List<String> lines = [];
      String currentLine = '';

      for (String word in words) {
        if ((currentLine.length + word.length) <= maxChars) {
          currentLine += '$word ';
        } else {
          lines.add(currentLine.trim());
          currentLine = '$word ';
        }
      }

      lines.add(currentLine.trim());
      return lines.join('\n');
    }

    String formatLoadingPoint(String loadingPoint) {
      if (loadingPoint.length > 150) {
        return loadingPoint.substring(0, 150) + '...';
      } else if (loadingPoint.length > 10) {
        return loadingPoint.replaceAllMapped(
            RegExp(r"(.{1,40})(?:\s|$)"), (match) => "${match.group(1)}\n");
      } else {
        return loadingPoint;
      }
    }

    String formatText(String text) {
      if (text.length > 30) {
        return text.substring(0, 30) + '...';
      } else {
        return text;
      }
    }

    uploadedCheckWeightReceipt() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "W");
      setState(() {
        docLinks = docLinks;
      });

      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "W");

          setState(() {
            availDocs = availDocs;
          });

          await assignDocNameWeightReceipt(availDocs[0]);
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
        }
      } else {
        await uploadFirstWeightReceipt();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        // to null the provider data of the documents variables after clicking the back button of the android device.

        print("After clicking the Android Back Button");
        // var providerData = Provider.of<ProviderData>(context);
        providerData.LrPhotoFile = null;
        providerData.LrPhoto64 = null;

        providerData.EwayBillPhotoFile = null;
        providerData.EwayBillPhoto64 = null;

        providerData.WeightReceiptPhotoFile = null;
        providerData.WeightReceiptPhoto64 = null;

        providerData.PodPhotoFile = null;
        providerData.PodPhoto64 = null;
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 246, 250, 1),
        body: Container(
          child: (providerData.LrPhotoFile !=
                  null) // to display the document upload screen only if the lr photo is selected by the user.
              ? SafeArea(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Container(
                          height: size_15 + 30,
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.back();
                                          setState(() {
                                            providerData.LrPhotoFile = null;
                                            providerData.LrPhoto64 = null;

                                            providerData.EwayBillPhotoFile =
                                                null;
                                            providerData.EwayBillPhoto64 = null;

                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                            providerData.WeightReceiptPhoto64 =
                                                null;

                                            providerData.PodPhotoFile = null;
                                            providerData.PodPhoto64 = null;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: darkBlueColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: space_1,
                                    ),
                                    Text(
                                      "Upload Image".tr,
                                      style: TextStyle(
                                          fontSize: size_10 - 1,
                                          fontWeight: boldWeight,
                                          color: darkBlueColor,
                                          letterSpacing: -0.408),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: size_3,
                          color: darkGreyColor,
                        ),
                        providerData.LrPhotoFile != null
                            ? Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    child: kIsWeb
                                        ? Image.network(
                                            providerData.LrPhotoFile!.path)
                                        : Image.file(providerData.LrPhotoFile!),
                                  ),
                                ),
                              )
                            : Container(),
                        Row(children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 7.5, bottom: 10, top: 10),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: const Color(0xFFE75347),
                                  child: SizedBox(
                                    height: space_10,
                                    child: Center(
                                      child: Text(
                                        "Discard".tr,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: size_9,
                                            fontWeight: mediumBoldWeight),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      providerData.LrPhotoFile = null;
                                    });
                                    providerData.LrPhotoFile = null;
                                  }),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.5, right: 15, bottom: 10, top: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                      onTapUp: (value) {
                                        setState(() {
                                          progressBar = true;
                                        });
                                      },
                                      onTap: uploadedCheckLr,
                                      child: Container(
                                        color: const Color(0xFF09B778),
                                        height: space_10,
                                        child: Center(
                                          child: progressBar
                                              ? const CircularProgressIndicator(
                                                  color: white,
                                                )
                                              : Text(
                                                  "Save".tr,
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: size_9,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      )),
                                )),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )
              : (providerData.EwayBillPhotoFile != null)
                  ? SafeArea(
                      child: Scaffold(
                        body: Column(
                          children: [
                            Container(
                              height: size_15 + 30,
                              color: whiteBackgroundColor,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Get.back();
                                              setState(() {
                                                providerData.LrPhotoFile = null;
                                                providerData.LrPhoto64 = null;

                                                providerData.EwayBillPhotoFile =
                                                    null;
                                                providerData.EwayBillPhoto64 =
                                                    null;

                                                providerData
                                                        .WeightReceiptPhotoFile =
                                                    null;
                                                providerData
                                                        .WeightReceiptPhoto64 =
                                                    null;

                                                providerData.PodPhotoFile =
                                                    null;
                                                providerData.PodPhoto64 = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.arrow_back_ios,
                                              color: darkBlueColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: space_1,
                                        ),
                                        Text(
                                          "Upload Image".tr,
                                          style: TextStyle(
                                              fontSize: size_10 - 1,
                                              fontWeight: boldWeight,
                                              color: darkBlueColor,
                                              letterSpacing: -0.408),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: size_3,
                              color: darkGreyColor,
                            ),
                            providerData.EwayBillPhotoFile != null
                                ? Expanded(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 10, right: 10),
                                        child: kIsWeb
                                            ? Image.network(providerData
                                                .EwayBillPhotoFile!.path)
                                            : Image.file(providerData
                                                .EwayBillPhotoFile!),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Row(children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 7.5,
                                      bottom: 10,
                                      top: 10),
                                  child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: const Color(0xFFE75347),
                                      child: SizedBox(
                                        height: space_10,
                                        child: Center(
                                          child: Text(
                                            "Discard".tr,
                                            style: TextStyle(
                                                color: white,
                                                fontSize: size_9,
                                                fontWeight: mediumBoldWeight),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          providerData.EwayBillPhotoFile = null;
                                        });
                                        providerData.EwayBillPhotoFile = null;
                                      }),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7.5,
                                        right: 15,
                                        bottom: 10,
                                        top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                          onTapUp: (value) {
                                            setState(() {
                                              progressBar = true;
                                            });
                                          },
                                          onTap: uploadedCheckEwayBill,
                                          child: Container(
                                            color: const Color(0xFF09B778),
                                            height: space_10,
                                            child: Center(
                                              child: progressBar
                                                  ? const CircularProgressIndicator(
                                                      color: white,
                                                    )
                                                  : Text(
                                                      "Save".tr,
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: size_9,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                          )),
                                    )),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    )
                  : (providerData.WeightReceiptPhotoFile != null)
                      ? SafeArea(
                          child: Scaffold(
                            body: Column(
                              children: [
                                Container(
                                  height: size_15 + 30,
                                  color: whiteBackgroundColor,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    providerData.LrPhotoFile =
                                                        null;
                                                    providerData.LrPhoto64 =
                                                        null;

                                                    providerData
                                                            .EwayBillPhotoFile =
                                                        null;
                                                    providerData
                                                        .EwayBillPhoto64 = null;

                                                    providerData
                                                            .WeightReceiptPhotoFile =
                                                        null;
                                                    providerData
                                                            .WeightReceiptPhoto64 =
                                                        null;

                                                    providerData.PodPhotoFile =
                                                        null;
                                                    providerData.PodPhoto64 =
                                                        null;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back_ios,
                                                  color: darkBlueColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: space_1,
                                            ),
                                            Text(
                                              "Upload Image".tr,
                                              style: TextStyle(
                                                  fontSize: size_10 - 1,
                                                  fontWeight: boldWeight,
                                                  color: darkBlueColor,
                                                  letterSpacing: -0.408),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: size_3,
                                  color: darkGreyColor,
                                ),
                                providerData.WeightReceiptPhotoFile != null
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, left: 10, right: 10),
                                            child: kIsWeb
                                                ? Image.network(providerData
                                                    .WeightReceiptPhotoFile!
                                                    .path)
                                                : Image.file(providerData
                                                    .WeightReceiptPhotoFile!),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Row(children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 7.5,
                                          bottom: 10,
                                          top: 10),
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          color: const Color(0xFFE75347),
                                          child: SizedBox(
                                            height: space_10,
                                            child: Center(
                                              child: Text(
                                                "Discard".tr,
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: size_9,
                                                    fontWeight:
                                                        mediumBoldWeight),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              providerData
                                                      .WeightReceiptPhotoFile =
                                                  null;
                                            });
                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.5,
                                            right: 15,
                                            bottom: 10,
                                            top: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: InkWell(
                                              onTapUp: (value) {
                                                setState(() {
                                                  progressBar = true;
                                                });
                                              },
                                              onTap: uploadedCheckWeightReceipt,
                                              child: Container(
                                                color: const Color(0xFF09B778),
                                                height: space_10,
                                                child: Center(
                                                  child: progressBar
                                                      ? const CircularProgressIndicator(
                                                          color: white,
                                                        )
                                                      : Text(
                                                          "Save".tr,
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: size_9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                              )),
                                        )),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        )
                      : (providerData.PodPhotoFile != null)
                          ? SafeArea(
                              child: Scaffold(
                                body: Column(
                                  children: [
                                    Container(
                                      height: size_15 + 30,
                                      color: whiteBackgroundColor,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Get.back();
                                                      setState(() {
                                                        providerData
                                                            .LrPhotoFile = null;
                                                        providerData.LrPhoto64 =
                                                            null;

                                                        providerData
                                                                .EwayBillPhotoFile =
                                                            null;
                                                        providerData
                                                                .EwayBillPhoto64 =
                                                            null;

                                                        providerData
                                                                .WeightReceiptPhotoFile =
                                                            null;
                                                        providerData
                                                                .WeightReceiptPhoto64 =
                                                            null;

                                                        providerData
                                                                .PodPhotoFile =
                                                            null;
                                                        providerData
                                                            .PodPhoto64 = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: darkBlueColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: space_1,
                                                ),
                                                Text(
                                                  "Upload Image".tr,
                                                  style: TextStyle(
                                                      fontSize: size_10 - 1,
                                                      fontWeight: boldWeight,
                                                      color: darkBlueColor,
                                                      letterSpacing: -0.408),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: size_3,
                                      color: darkGreyColor,
                                    ),
                                    providerData.PodPhotoFile != null
                                        ? Expanded(
                                            child: SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 10,
                                                    right: 10),
                                                child: kIsWeb
                                                    ? Image.network(providerData
                                                        .PodPhotoFile!.path)
                                                    : Image.file(providerData
                                                        .PodPhotoFile!),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Row(children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 7.5,
                                              bottom: 10,
                                              top: 10),
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              color: const Color(0xFFE75347),
                                              child: SizedBox(
                                                height: space_10,
                                                child: Center(
                                                  child: Text(
                                                    "Discard".tr,
                                                    style: TextStyle(
                                                        color: white,
                                                        fontSize: size_9,
                                                        fontWeight:
                                                            mediumBoldWeight),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  providerData.PodPhotoFile =
                                                      null;
                                                });
                                                providerData.PodPhotoFile =
                                                    null;
                                              }),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7.5,
                                                right: 15,
                                                bottom: 10,
                                                top: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: InkWell(
                                                  onTapUp: (value) {
                                                    setState(() {
                                                      progressBar = true;
                                                    });
                                                  },
                                                  onTap: uploadedCheckPod,
                                                  child: Container(
                                                    color:
                                                        const Color(0xFF09B778),
                                                    height: space_10,
                                                    // width: space_30,
                                                    child: Center(
                                                      child: progressBar
                                                          ? const CircularProgressIndicator(
                                                              color: white,
                                                            )
                                                          : Text(
                                                              "Save".tr,
                                                              style: TextStyle(
                                                                  color: white,
                                                                  fontSize:
                                                                      size_9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                      // ),
                                                    ),
                                                  )),
                                            )),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              // this will be displayed if any document is not selected for uploading.
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Container(
                                      // alignment: Alignment.topLeft,
                                      child: const Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child: Text(
                                          "Loads",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  21, 41, 104, 1),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //header
                                  Material(
                                    elevation: 5,
                                    child: Container(
                                      height: size_15 + 50,
                                      color: white,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                      providerData.LrPhotoFile =
                                                          null;
                                                      providerData.LrPhoto64 =
                                                          null;

                                                      providerData
                                                              .EwayBillPhotoFile =
                                                          null;
                                                      providerData
                                                              .EwayBillPhoto64 =
                                                          null;

                                                      providerData
                                                              .WeightReceiptPhotoFile =
                                                          null;
                                                      providerData
                                                              .WeightReceiptPhoto64 =
                                                          null;

                                                      providerData
                                                          .PodPhotoFile = null;
                                                      providerData.PodPhoto64 =
                                                          null;
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: darkBlueColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: space_1,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Loads Details",
                                                      style: TextStyle(
                                                          fontSize: size_10 - 1,
                                                          fontWeight:
                                                              boldWeight,
                                                          color: darkBlueColor,
                                                          letterSpacing:
                                                              -0.408),
                                                    ),
                                                    Text(
                                                      "On Going load details",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size_10 - 10,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 50,
                                  ),
                                  //from to widget
                                  Material(
                                    elevation: 5,
                                    child: Container(
                                        padding: EdgeInsets.all(
                                            isMobile ? 20.0 : 30.0),
                                        width: screenWidth * 0.9,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: screenHeight / 90),
                                              color: const Color(0xfff4f4f4),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: isMobile
                                                        ? screenHeight * 0.001
                                                        : screenWidth * 0.01),
                                                child: (loadData != null)
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      0,
                                                                      20,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  const Image(
                                                                    image: AssetImage(
                                                                        'assets/icons/greenFilledCircleIcon.png'),
                                                                    height: 10,
                                                                    width: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth *
                                                                            0.02,
                                                                        0,
                                                                        screenWidth *
                                                                            0.02,
                                                                        0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${widget.loadingPoint}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                mediumBoldWeight,
                                                                            color:
                                                                                liveasyBlackColor,
                                                                            fontSize: isMobile
                                                                                ? screenWidth * 0.032
                                                                                : screenHeight * 0.03,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * ((Responsive.isTablet(context)) ? 0.1 : 0.25),
                                                                          child:
                                                                              Text(
                                                                            "${loadData?['loadingPoint']}, ${loadData?['loadingPointCity']}, ${loadData?['loadingPointState']}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: Responsive.isMobile(context) ? 10 : 16,
                                                                              color: darkBlueColor,
                                                                            ),
                                                                            maxLines:
                                                                                5,
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Expanded(
                                                                child:
                                                                    DottedLine(
                                                              direction: Axis
                                                                  .horizontal,
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              lineLength: double
                                                                  .infinity,
                                                              lineThickness:
                                                                  2.0,
                                                              dashLength: 4.0,
                                                              dashColor:
                                                                  kLiveasyColor,
                                                              dashRadius: 0.0,
                                                              dashGapLength:
                                                                  4.0,
                                                              dashGapColor: Colors
                                                                  .transparent,
                                                              dashGapRadius:
                                                                  0.0,
                                                            )),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              color:
                                                                  kLiveasyColor,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      screenWidth *
                                                                          0.02,
                                                                      0,
                                                                      screenWidth *
                                                                          0.02,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  const Image(
                                                                    image: AssetImage(
                                                                        'assets/icons/unloadingPoint.png'),
                                                                    height: 10,
                                                                    width: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth *
                                                                            0.02,
                                                                        0,
                                                                        screenWidth *
                                                                            0.02,
                                                                        0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${widget.unloadingPoint}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                mediumBoldWeight,
                                                                            color:
                                                                                liveasyBlackColor,
                                                                            fontSize: isMobile
                                                                                ? screenWidth * 0.032
                                                                                : screenHeight * 0.03,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * ((Responsive.isTablet(context)) ? 0.1 : 0.25),
                                                                          child:
                                                                              Text(
                                                                            '${(loadData?['unloadingPoint'])}, ${loadData?['unloadingPointCity']} , ${loadData?['unloadingPointState']}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: Responsive.isMobile(context) ? 10 : 16,
                                                                              color: darkBlueColor,
                                                                            ),
                                                                            maxLines:
                                                                                5,
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ])
                                                    : Container(),
                                              ),
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                            Responsive.isMobile(context)
                                                ? Container()
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                screenHeight /
                                                                    90),
                                                    color:
                                                        const Color(0xfff1f4ff),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 20.0,
                                                          horizontal: isMobile
                                                              ? screenHeight *
                                                                  0.001
                                                              : screenWidth *
                                                                  0.01),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 50,
                                                          ),
                                                          const Image(
                                                            image: AssetImage(
                                                                'assets/icons/box.png'),
                                                          ),
                                                          Text(
                                                            " DOC",
                                                            style: TextStyle(
                                                                color:
                                                                    veryDarkGrey,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    mediumBoldWeight),
                                                          ),
                                                          const SizedBox(
                                                            width: 100,
                                                          ),
                                                          const Image(
                                                            image: AssetImage(
                                                                'assets/icons/truckDoc.png'),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                ((Responsive.isTablet(
                                                                        context))
                                                                    ? 0.1
                                                                    : 0.25),
                                                            child: Text(
                                                              " ${loadData?['weight']} tons| ${loadData?['truckType']} | ${loadData?['noOfTyres']} Tyres  ",
                                                              style: TextStyle(
                                                                  color:
                                                                      veryDarkGrey,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      mediumBoldWeight),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                          ],
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Responsive.isMobile(context)
                                      ? Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Material(
                                            elevation: 5,
                                            child: SizedBox(
                                              height: screenHeight / 8,
                                              width: screenWidth * 0.9,
                                              child: Container(
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: Text(
                                                        " Track Vehicle ",
                                                        style: TextStyle(
                                                            color:
                                                                darkBlueColor,
                                                            fontSize: size_9,
                                                            fontWeight:
                                                                mediumBoldWeight),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: TrackButton(
                                                          assetImage:
                                                              'assets/icons/location2.png',
                                                          name: "Gps",
                                                          loadAllDataModel: widget
                                                              .loadAllDataModel!),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: InkWell(
                                                        onTap: () {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder:
                                                          //           (context) =>
                                                          //               MapScreen(
                                                          //                 loadingPoint:
                                                          //                     widget.loadingPoint,
                                                          //                 unloadingPoint:
                                                          //                     widget.unloadingPoint,
                                                          //                 truckNumber:
                                                          //                     widget.truckNo,
                                                          //               )),
                                                          // );
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreenWeb(
                                                                          visibleWidget:
                                                                              MapScreen(
                                                                            loadingPoint:
                                                                                widget.loadingPoint,
                                                                            unloadingPoint:
                                                                                widget.unloadingPoint,
                                                                            truckNumber:
                                                                                widget.truckNo,
                                                                          ),
                                                                          index:
                                                                              1000,
                                                                          selectedIndex:
                                                                              screens.indexOf(postLoadScreen),
                                                                        )),
                                                          );
                                                        },
                                                        child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        screenWidth *
                                                                            0.005),
                                                            height: isMobile
                                                                ? screenHeight *
                                                                    0.03
                                                                : screenHeight *
                                                                    0.04,
                                                            width: isMobile
                                                                ? screenHeight *
                                                                    0.07
                                                                : screenWidth *
                                                                    0.09,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              2)),
                                                              color:
                                                                  trackButtonColor,
                                                            ),
                                                            child: Image.asset(
                                                                'assets/icons/fastag.png')),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Material(
                                            elevation: 5,
                                            child: SizedBox(
                                              height: screenHeight / 8,
                                              width: screenWidth * 0.9,
                                              child: Container(
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: Text(
                                                        " Track Vehicle ",
                                                        style: TextStyle(
                                                            color:
                                                                darkBlueColor,
                                                            fontSize: size_13,
                                                            fontWeight:
                                                                mediumBoldWeight),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: TrackButton(
                                                          assetImage:
                                                              'assets/icons/location2.png',
                                                          name: "Gps",
                                                          loadAllDataModel: widget
                                                              .loadAllDataModel!),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: TrackButton(
                                                          assetImage:
                                                              'assets/icons/microSim.png',
                                                          name: "Sim",
                                                          loadAllDataModel: widget
                                                              .loadAllDataModel!),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          screenWidth * 0.02),
                                                      child: InkWell(
                                                        onTap: () {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder:
                                                          //           (context) =>
                                                          //               MapScreen(
                                                          //                 loadingPoint:
                                                          //                     widget.loadingPoint,
                                                          //                 unloadingPoint:
                                                          //                     widget.unloadingPoint,
                                                          //                 truckNumber:
                                                          //                     widget.truckNo,
                                                          //               )),
                                                          // );
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreenWeb(
                                                                          visibleWidget:
                                                                              MapScreen(
                                                                            loadingPoint:
                                                                                widget.loadingPoint,
                                                                            unloadingPoint:
                                                                                widget.unloadingPoint,
                                                                            truckNumber:
                                                                                widget.truckNo,
                                                                          ),
                                                                          index:
                                                                              1000,
                                                                          selectedIndex:
                                                                              screens.indexOf(postLoadScreen),
                                                                        )),
                                                          );
                                                        },
                                                        child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        screenWidth *
                                                                            0.005),
                                                            height: isMobile
                                                                ? screenHeight *
                                                                    0.03
                                                                : screenHeight *
                                                                    0.04,
                                                            width: isMobile
                                                                ? screenHeight *
                                                                    0.07
                                                                : screenWidth *
                                                                    0.09,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              2)),
                                                              color:
                                                                  trackButtonColor,
                                                            ),
                                                            child: Image.asset(
                                                                'assets/icons/fastag.png')),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Material(
                                      elevation: 5,
                                      child: Container(
                                        height: screenHeight * 0.1,
                                        color: white,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              50, 0, 100, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Driver Details",
                                                  style: TextStyle(
                                                      color: darkBlueTextColor,
                                                      fontWeight:
                                                          mediumBoldWeight,
                                                      fontSize:
                                                          Responsive.isMobile(
                                                                  context)
                                                              ? 16
                                                              : 26)),
                                              const SizedBox(width: 20),
                                              EditDriverDetail(
                                                bookingId:
                                                    widget.bookingId.toString(),
                                                driverName: widget.driverName,
                                                driverPhoneNum:
                                                    widget.driverPhoneNum,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Material(
                                      elevation: 5,
                                      child: Container(
                                          color: Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3.7,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Booking Date",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.bookingDate}")),
                                                    ),
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Driver Number.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.driverPhoneNum}")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Truck\nNumber",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.truckNo}")),
                                                    ),
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "LR Number",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: const Center(
                                                          child: Text(
                                                        "Hm98765432110112",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Driver Name",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.driverName}")),
                                                    ),
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Frieght",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: const Center(
                                                          child: Text(
                                                        "17,000",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Sim-Tracking Consent status ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                            side: MaterialStateProperty
                                                                .all(BorderSide(
                                                                    color: getStatusColor(
                                                                        status),
                                                                    width:
                                                                        2.0)),
                                                          ),
                                                          child: Text(
                                                            ' $status',
                                                            style: TextStyle(
                                                              color:
                                                                  getStatusColor(
                                                                      status),
                                                            ),
                                                          )),
                                                    ),
                                                    Container(
                                                      width: screenWidth * 0.15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Vehicle Details",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.15,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            // Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //       builder:
                                                            //           (context) =>
                                                            //               VehicleDetailsScreen(
                                                            //                 truckNumber:
                                                            //                     widget.truckNo,
                                                            //               )),
                                                            // );
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          HomeScreenWeb(
                                                                            visibleWidget:
                                                                                VehicleDetailsScreen(
                                                                              truckNumber: widget.truckNo,
                                                                            ),
                                                                            index:
                                                                                1000,
                                                                            selectedIndex:
                                                                                screens.indexOf(postLoadScreen),
                                                                          )),
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                            side: MaterialStateProperty.all(
                                                                const BorderSide(
                                                                    color:
                                                                        kLiveasyColor,
                                                                    width:
                                                                        2.0)),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    100,
                                                                    10,
                                                                    10,
                                                                    10),
                                                            child: Container(
                                                              height: isMobile
                                                                  ? screenHeight *
                                                                      0.03
                                                                  : screenHeight *
                                                                      0.03,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: isMobile
                                                                  ? screenHeight *
                                                                      0.065
                                                                  : 100,
                                                              child: const Text(
                                                                "View ",
                                                                style: TextStyle(
                                                                    color:
                                                                        kLiveasyColor),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Material(
                                      elevation: 5,
                                      child: Container(
                                        height: screenHeight * 0.125,
                                        color: white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Sim-Tracking Consent :",
                                                style: TextStyle(
                                                  color: darkBlueColor,
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 12
                                                      : 26,
                                                  fontWeight: mediumBoldWeight,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    Responsive.isMobile(context)
                                                        ? 10
                                                        : 30,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          space_1),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: selectedOperator,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down_sharp),
                                                  style: const TextStyle(
                                                      color: black),
                                                  underline: Container(
                                                    height: 2,
                                                    color: white,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedOperator =
                                                          newValue;
                                                    });
                                                  },
                                                  items: operatorOptions
                                                      .map((String operator) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: operator,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            space_2),
                                                        child: SizedBox(
                                                          width: 100,
                                                          height: 28,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            space_2),
                                                                child: Text(
                                                                  operator,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          size_7),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    Responsive.isMobile(context)
                                                        ? 10
                                                        : 30,
                                              ),
                                              SendConsentButton(
                                                selectedOperator:
                                                    selectedOperator,
                                                title: 'Send',
                                                mobileno: widget.driverPhoneNum,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 30),
                                    child: ElevatedButton(onPressed: () async{
                                      TextEditingController lrController = TextEditingController();

                                      await showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          contentPadding: const EdgeInsets.all(15),
                                          content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 20, width: 300,),
                                            TextFormField(
                                              controller: lrController,
                                              style: TextStyle(
                                                  color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.zero,
                                                      borderSide: BorderSide(color: borderLightColor, width: 1.5)),
                                                  hintText: 'Enter Eway Bill No',
                                                  hintStyle: TextStyle(
                                                      color: borderLightColor,
                                                      fontFamily: 'Montserrat',
                                                      fontSize: size_8),
                                                  label: Text('Eway bill no',
                                                      style: TextStyle(
                                                          color: kLiveasyColor,
                                                          fontFamily: 'Montserrat',
                                                          fontSize: size_10,
                                                          fontWeight: FontWeight.w600),
                                                      selectionColor: kLiveasyColor),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.zero,
                                                      borderSide: BorderSide(color: truckGreen, width: 1.5))),
                                            ),
                                            const SizedBox(height: 20,),
                                            ElevatedButton(
                                              onPressed: () {
                                                if(lrController.text.isNotEmpty){
                                                  Navigator.pop(context);
                                                }
                                                else{
                                                  showSnackBar(
                                                      'Enter Eway Bill no',
                                                      deleteButtonColor,
                                                      const Icon(Icons.warning),
                                                      context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                backgroundColor: truckGreen
                                              ),
                                              child: Text('Submit', style: TextStyle(color: white, fontFamily: 'Montserrat', fontSize: size_9)),
                                            )
                                          ],
                                        ),);
                                      },);
                                      var response = await getLrDetails(lrController.text);
                                      if(response!=null){
                                        try{
                                          createPdf(response['transporterName'].toString() ?? '', response['fromAddr1'].toString() ?? '', response['ewbNo'].toString() ?? '',response['fromAddr1'].toString() ?? '', response['toAddr1'].toString() ?? '', response['vehicleListDetails'][0]['vehicleNo'].toString() ?? '', response['docDate'].toString() ?? '', response['fromTrdName'].toString() ?? '', response['fromGstin'].toString() ?? '', response['toTrdName'].toString() ?? '', response['toGstin'].toString() ?? '', response['itemListDetails'][0]['quantity'].toString() ?? '', response['itemListDetails'][0]['qtyUnit'].toString() ?? '', response['itemListDetails'][0]['productName'].toString() ?? '', response['itemListDetails'][0]['hsnCode'].toString() ?? '');
                                        }
                                        catch(error){
                                          showSnackBar(
                                              'User or Eway bill not found',
                                              deleteButtonColor,
                                              Icon(Icons.warning),
                                              context);
                                        }
                                      }
                                      else{
                                        showSnackBar(
                                            'Could not generate any LR for given no',
                                            deleteButtonColor,
                                            Icon(Icons.warning),
                                            context);
                                      }
                                    },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kLiveasyColor,
                                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                                        ),
                                        child: Text('Generate LR', style: TextStyle(color: white, fontFamily: 'Montserrat', fontSize: size_9),)),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Material(
                                      elevation: 5,
                                      child: Container(
                                        height: 70,
                                        color: white,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(space_4,
                                              space_4, space_4, space_4),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Uploaded Documents",
                                              style: TextStyle(
                                                  color: const Color.fromRGBO(
                                                      21, 41, 104, 1),
                                                  fontWeight: boldWeight,
                                                  fontSize: size_10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Responsive.isMobile(context)
                                      ? Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Material(
                                            elevation: 5,
                                            child: Container(
                                              color: white,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_2,
                                                            space_4,
                                                            0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Loading Documents"
                                                              .tr,
                                                          style: TextStyle(
                                                              color: grey,
                                                              fontSize: size_9,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_1,
                                                            space_4,
                                                            0),
                                                    child: Text(
                                                      "Upload Loadoing document photos for advanced payment"
                                                          .tr,
                                                      style: const TextStyle(
                                                          color: grey),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_4,
                                                              space_4,
                                                              space_4,
                                                              0),
                                                      child: docInputLr(
                                                          providerData:
                                                              providerData,
                                                          bookingId: widget
                                                              .bookingId)),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_4,
                                                              space_4,
                                                              space_4,
                                                              0),
                                                      child: docInputEWBill(
                                                          providerData:
                                                              providerData,
                                                          bookingId: widget
                                                              .bookingId)),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_4,
                                                              space_4,
                                                              space_4,
                                                              0),
                                                      child: docInputWgtReceipt(
                                                        providerData:
                                                            providerData,
                                                        bookingId:
                                                            widget.bookingId,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_4,
                                                            space_4,
                                                            0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Uploading Documents"
                                                              .tr,
                                                          style: TextStyle(
                                                              color: grey,
                                                              fontSize: size_9,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_1,
                                                            space_4,
                                                            0),
                                                    child: Text(
                                                      "Upload unloadoing document photos for final payment"
                                                          .tr,
                                                      style: const TextStyle(
                                                          color: grey),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_4,
                                                            space_4,
                                                            space_4),
                                                    child: docInputPod(
                                                      providerData:
                                                          providerData,
                                                      bookingId:
                                                          widget.bookingId,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Material(
                                            elevation: 5,
                                            child: Container(
                                              color: white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  space_4,
                                                                  space_4,
                                                                  space_4,
                                                                  space_4),
                                                          child: docInputLr(
                                                              providerData:
                                                                  providerData,
                                                              bookingId: widget
                                                                  .bookingId),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    space_4,
                                                                    space_4,
                                                                    space_4,
                                                                    space_4),
                                                            child: docInputEWBill(
                                                                providerData:
                                                                    providerData,
                                                                bookingId: widget
                                                                    .bookingId)),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 70,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  space_4,
                                                                  space_4,
                                                                  space_4,
                                                                  space_4),
                                                          child:
                                                              docInputWgtReceipt(
                                                            providerData:
                                                                providerData,
                                                            bookingId: widget
                                                                .bookingId,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  space_4,
                                                                  space_4,
                                                                  space_4,
                                                                  space_4),
                                                          child: docInputPod(
                                                            providerData:
                                                                providerData,
                                                            bookingId: widget
                                                                .bookingId,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'APPROVED':
      return liveasyGreen;
    case 'PENDING':
      return orangeColor;
    case 'REJECTED':
      return red;
    default:
      return black;
  }
}
