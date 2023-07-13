import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Widgets/LoadsTableHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:shipper_app/models/loadDetailsScreenModel.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/widgets/MyLoadsCard.dart';
import 'package:shipper_app/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:shipper_app/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pagination_flutter/pagination.dart';

class MyLoadsScreen extends StatefulWidget {
  const MyLoadsScreen({super.key});

  @override
  _MyLoadsScreenState createState() => _MyLoadsScreenState();
}

class _MyLoadsScreenState extends State<MyLoadsScreen> {
  List<LoadDetailsScreenModel> myLoadList = [];
  List<LoadDetailsScreenModel> selectedLoadList = [];

  int selectedPage = 1;

  // final String loadApiUrl = FlutterConfig.get("loadApiUrl");
  final String loadApiUrl = dotenv.get('loadApiUrl');

  ScrollController scrollController = ScrollController();

  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  int i = 0;

  bool loading = false;
  bool bottomProgressLoad = false;

  @override
  void initState() {
    super.initState();

    loading = true;
    getDataByPostLoadId(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        getDataByPostLoadId(i);
      }
      // else{
      //   setState(() {
      //     if(scrollController.position.pixels>scrollController.position.minScrollExtent){
      //       ++selectedPage;
      //     }
      //     else{
      //       --selectedPage;
      //     }
      //   });
      //
      // }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_8,
        child: loading
            ? const OnGoingLoadingWidgets()
            : myLoadList.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 153),
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage('assets/images/EmptyLoad.png'),
                          height: 127,
                          width: 127,
                        ),
                        Text(
                          'noLoadAdded'.tr,
                          // 'Looks like you have not added any Loads!',
                          style: TextStyle(fontSize: size_8, color: grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: lightNavyBlue,
                    onRefresh: () {
                      setState(() {
                        myLoadList.clear();
                        loading = true;
                      });
                      return getDataByPostLoadId(0);
                    },
                    child: (kIsWeb && Responsive.isDesktop(context))
                        ? Center(
                            child: Card(
                              margin: EdgeInsets.only(top: 20, bottom: 5),
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              elevation: 10,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LoadsTableHeader(
                                        loadingStatus: 'MyLoads',
                                        screenWidth:
                                            MediaQuery.of(context).size.width),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: ListView.separated(
                                        primary: false,
                                        physics: const BouncingScrollPhysics(),
                                        // physics: const AlwaysScrollableScrollPhysics (),
                                        scrollDirection: Axis.vertical,
                                        padding:
                                            EdgeInsets.only(bottom: space_15),
                                        controller: scrollController,
                                        itemCount: myLoadList.length,
                                        itemBuilder: (context, index) => (index ==
                                                myLoadList
                                                    .length) //removed -1 here
                                            ? Visibility(
                                                visible: bottomProgressLoad,
                                                child:
                                                    const bottomProgressBarIndicatorWidget())
                                            : Row(children: [
                                                MyLoadsCard(
                                                  loadDetailsScreenModel:
                                                      myLoadList[index],
                                                ),
                                              ]),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 10, top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Pagination(
                                            numOfPages:
                                                (myLoadList.length / 15).ceil(),
                                            selectedPage: selectedPage,
                                            pagesVisible: 1,
                                            onPageChanged: (index) {
                                              setState(() {
                                                selectedPage = index;
                                              });
                                            },
                                            activeTextStyle: TextStyle(
                                                fontSize: 14,
                                                color: kLiveasyColor,
                                                fontFamily: 'Montserrat Bold',
                                                fontWeight: FontWeight.w700),
                                            activeBtnStyle: ButtonStyle(
                                                iconColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(kLiveasyColor),
                                                padding:
                                                    MaterialStatePropertyAll<
                                                            EdgeInsets>(
                                                        EdgeInsets.all(10))),
                                            nextIcon: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              weight: 100,
                                              size: 25,
                                            ),
                                            previousIcon: Icon(
                                              Icons.arrow_back_ios_sharp,
                                              weight: 100,
                                              size: 25,
                                            ),
                                            inactiveBtnStyle: ButtonStyle(
                                                iconColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.grey),
                                                padding:
                                                    MaterialStatePropertyAll<
                                                            EdgeInsets>(
                                                        EdgeInsets.all(10))),
                                            inactiveTextStyle: TextStyle(
                                                fontSize: 14,
                                                color: kLiveasyColor,
                                                fontFamily: 'Montserrat Bold',
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: space_15),
                            controller: scrollController,
                            itemCount: myLoadList.length,
                            itemBuilder: (context, index) => (index ==
                                    myLoadList.length) //removed -1 here
                                ? Visibility(
                                    visible: bottomProgressLoad,
                                    child:
                                        const bottomProgressBarIndicatorWidget())
                                : MyLoadsCard(
                                    loadDetailsScreenModel: myLoadList[index],
                                  ),
                          )));
  }

  getDataByPostLoadId(int i) async {
    if (mounted) {
      setState(() {
        bottomProgressLoad = true;
      });
    }
    http.Response response = await http.get(Uri.parse(
        '$loadApiUrl?postLoadId=${shipperIdController.shipperId.value}&pageNo=$i'));
    var jsonData = json.decode(response.body);
    for (var json in jsonData) {
      LoadDetailsScreenModel loadDetailsScreenModel = LoadDetailsScreenModel();
      loadDetailsScreenModel.loadId = json['loadId'];
      loadDetailsScreenModel.loadingPointCity =
          json['loadingPointCity'] ?? 'NA';
      loadDetailsScreenModel.loadingPoint = json['loadingPoint'] ?? 'NA';
      loadDetailsScreenModel.loadingPointState =
          json['loadingPointState'] ?? 'NA';
      loadDetailsScreenModel.loadingPointCity2 =
          json['loadingPointCity2'] ?? 'NA';
      loadDetailsScreenModel.loadingPoint2 = json['loadingPoint2'] ?? 'NA';
      loadDetailsScreenModel.loadingPointState2 =
          json['loadingPointState2'] ?? 'NA';
      loadDetailsScreenModel.unloadingPointCity =
          json['unloadingPointCity'] ?? 'NA';
      loadDetailsScreenModel.unloadingPoint = json['unloadingPoint'] ?? 'NA';
      loadDetailsScreenModel.unloadingPointState =
          json['unloadingPointState'] ?? 'NA';
      loadDetailsScreenModel.unloadingPointCity2 =
          json['unloadingPointCity2'] ?? 'NA';
      loadDetailsScreenModel.unloadingPoint2 = json['unloadingPoint2'] ?? 'NA';
      loadDetailsScreenModel.unloadingPointState2 =
          json['unloadingPointState2'] ?? 'NA';
      loadDetailsScreenModel.postLoadId = json['postLoadId'];
      loadDetailsScreenModel.truckType = json['truckType'] ?? 'NA';
      loadDetailsScreenModel.weight = json['weight'] ?? 'NA';
      loadDetailsScreenModel.productType = json['productType'] ?? 'NA';
      loadDetailsScreenModel.rate =
          json['rate'] != null ? json['rate'].toString() : 'NA';
      loadDetailsScreenModel.unitValue = json['unitValue'] ?? 'NA';
      loadDetailsScreenModel.noOfTyres = json['noOfTyres'] ?? 'NA';
      loadDetailsScreenModel.loadDate = json['loadDate'] ?? 'NA';
      loadDetailsScreenModel.postLoadDate = json['postLoadDate'] ?? 'NA';
      loadDetailsScreenModel.status = json['status'];
      if (mounted) {
        setState(() {
          selectedPage = i + 1;
          myLoadList.add(loadDetailsScreenModel);
        });
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
        bottomProgressLoad = false;
      });
    }
  } //builder
} //class end
