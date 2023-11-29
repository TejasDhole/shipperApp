import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Widgets/biddingScreenWidget/biddingScreenTableHeader.dart';
import 'package:shipper_app/Widgets/buttons/backButtonWidget.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/postLoadScreen.dart';
import '../../functions/transporterApis/transporterApiCalls.dart';
import '../../models/transporterModel.dart';
import '/constants/spaces.dart';
import '/functions/shipperApis/shipperApiCalls.dart';
import '/models/biddingModel.dart';
import '/providerClass/providerData.dart';
import '/widgets/Header.dart';
import '/widgets/biddingsCardShipperSide.dart';
import '/widgets/loadingWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shipper_app/Widgets/loadingWidget.dart';

class BiddingScreens extends StatefulWidget {
  final String? loadId;
  final String? loadingPointCity;
  final String? unloadingPointCity;

  BiddingScreens(
      {required this.loadId,
      required this.loadingPointCity,
      required this.unloadingPointCity});

  @override
  _BiddingScreensState createState() => _BiddingScreensState();
}

class _BiddingScreensState extends State<BiddingScreens> {
  // final String biddingApiUrl = FlutterConfig.get('biddingApiUrl');
  final String biddingApiUrl = dotenv.get('biddingApiUrl');

  int i = 0;
  late List jsonData;

  bool loading = false;

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  ShipperApiCalls shipperApiCalls = ShipperApiCalls();
  TransporterApiCalls transporterApiCalls = TransporterApiCalls();

  List<BiddingModel> biddingModelList = [];
  List<TransporterModel> transporterModelList = [];

  getBidDataByLoadId(int i) async {
    http.Response response = await http
        .get(Uri.parse('$biddingApiUrl?loadId=${widget.loadId}&pageNo=$i'));

    jsonData = json.decode(response.body);

    for (var json in jsonData) {
      BiddingModel biddingModel = BiddingModel();
      TransporterModel transporterModel = TransporterModel();

      biddingModel.bidId = json['bidId'] != null ? json['bidId'] : 'Na';
      biddingModel.transporterId =
          json['transporterId'] != null ? json['transporterId'] : 'Na';
      biddingModel.currentBid =
          json['currentBid'] == null ? 'NA' : json['currentBid'].toString();
      biddingModel.previousBid =
          json['previousBid'] == null ? 'NA' : json['previousBid'].toString();
      biddingModel.unitValue =
          json['unitValue'] != null ? json['unitValue'] : 'Na';
      biddingModel.loadId = json['loadId'] != null ? json['loadId'] : 'Na';
      biddingModel.biddingDate =
          json['biddingDate'] != null ? json['biddingDate'] : 'NA';
      biddingModel.truckIdList =
          json['truckId'] != null ? json['truckId'] : 'Na';
      biddingModel.transporterApproval = json['transporterApproval'];
      biddingModel.shipperApproval = json['shipperApproval'];

      transporterModel = await transporterApiCalls
          .getDataByTransporterId(biddingModel.transporterId);

      setState(() {
        loading = true;
        transporterModelList.add(transporterModel);
        biddingModelList.add(biddingModel);
      });
    }
    loading = false;
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getBidDataByLoadId(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getBidDataByLoadId(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        providerData.updateBidEndpoints(
            widget.loadingPointCity, widget.unloadingPointCity));
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: headerLightBlueColor,
            ),
            child: Row(
              children: [
                Visibility(
                  visible: (Responsive.isMobile(context)) ? true : false,
                  child: BackButtonWidget(
                      previousPage: PostLoadScreen(),
                      selectedIndex: screens.indexOf(postLoadScreen)),
                ),
                Visibility(
                    visible: (Responsive.isMobile(context)) ? true : false,
                    child: SizedBox(
                      width: 20,
                    )),
                Text('bids'.tr,
                    style: TextStyle(
                      fontSize: size_10 - 1,
                      fontWeight: mediumBoldWeight,
                    )),
              ],
            ),
          ),
          Visibility(
            visible: (Responsive.isMobile(context)) ? false : true,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Row(
                children: [
                  BackButtonWidget(
                      previousPage: PostLoadScreen(),
                      selectedIndex: screens.indexOf(postLoadScreen)),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      style: TextStyle(
                          color: kLiveasyColor,
                          fontFamily: 'Montserrat',
                          fontSize: size_8),
                      textAlign: TextAlign.center,
                      cursorColor: kLiveasyColor,
                      cursorWidth: 1,
                      mouseCursor: SystemMouseCursors.click,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                  color: borderLightColor, width: 1.5)),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: borderLightColor,
                              fontFamily: 'Montserrat',
                              fontSize: size_8),
                          suffixIcon: Icon(
                            Icons.search,
                            color: borderLightColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide:
                                  BorderSide(color: truckGreen, width: 1.5))),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            color: lineDividerColor,
          ),
          Expanded(
              child: Align(
            alignment: Responsive.isMobile(context)
                ? Alignment.topCenter
                : Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.65,
              child: loading
                  ? LoadingWidget()
                  : biddingModelList.isEmpty
                      ? Center(
                          child: Text(
                            'noBid'.tr,
                            // 'No bids yet'
                          ),
                        )
                      : (Responsive.isTablet(context) ||
                              Responsive.isDesktop(context))
                          ? Card(
                              surfaceTintColor: transparent,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              color: white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  biddingScreenTableHeader(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    controller: scrollController,
                                    itemCount: biddingModelList.length,
                                    itemBuilder: (context, index) {
                                      return BiddingsCardShipperSide(
                                        index: index + 1,
                                        loadId: widget.loadId,
                                        loadingPointCity:
                                            widget.loadingPointCity,
                                        unloadingPointCity:
                                            widget.unloadingPointCity,
                                        currentBid:
                                            biddingModelList[index].currentBid,
                                        previousBid:
                                            biddingModelList[index].previousBid,
                                        unitValue:
                                            biddingModelList[index].unitValue,
                                        companyName: transporterModelList[index]
                                            .companyName,
                                        transporterEmail:
                                            transporterModelList[index]
                                                .transporterEmail,
                                        biddingDate:
                                            biddingModelList[index].biddingDate,
                                        bidId: biddingModelList[index].bidId,
                                        transporterPhoneNum:
                                            transporterModelList[index]
                                                .transporterPhoneNum,
                                        transporterLocation:
                                            transporterModelList[index]
                                                .transporterLocation,
                                        transporterName:
                                            transporterModelList[index]
                                                .transporterName,
                                        shipperApproved: biddingModelList[index]
                                            .shipperApproval,
                                        transporterApproved:
                                            biddingModelList[index]
                                                .transporterApproval,
                                        isLoadPosterVerified:
                                            transporterModelList[index]
                                                .companyApproved,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(
                                        color: unselectedGrey,
                                        thickness: 1,
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: biddingModelList.length,
                              itemBuilder: (context, index) {
                                return BiddingsCardShipperSide(
                                  index: index + 1,
                                  loadId: widget.loadId,
                                  loadingPointCity: widget.loadingPointCity,
                                  unloadingPointCity: widget.unloadingPointCity,
                                  currentBid:
                                      biddingModelList[index].currentBid,
                                  previousBid:
                                      biddingModelList[index].previousBid,
                                  unitValue: biddingModelList[index].unitValue,
                                  companyName:
                                      transporterModelList[index].companyName,
                                  transporterEmail: transporterModelList[index]
                                      .transporterEmail,
                                  biddingDate:
                                      biddingModelList[index].biddingDate,
                                  bidId: biddingModelList[index].bidId,
                                  transporterPhoneNum:
                                      transporterModelList[index]
                                          .transporterPhoneNum,
                                  transporterLocation:
                                      transporterModelList[index]
                                          .transporterLocation,
                                  transporterName: transporterModelList[index]
                                      .transporterName,
                                  shipperApproved:
                                      biddingModelList[index].shipperApproval,
                                  transporterApproved: biddingModelList[index]
                                      .transporterApproval,
                                  isLoadPosterVerified:
                                      transporterModelList[index]
                                          .companyApproved,
                                );
                              }),
            ),
          ))
        ],
      ),
    ));
  }
} //class end
