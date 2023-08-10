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
  List<LoadDetailsScreenModel> searchedLoadList = [];
  TextEditingController searchTextController = TextEditingController();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child: TextField(
                      controller: searchTextController,
                      onChanged: (value) {
                        if (value.length > 2) {
                          getSearchLoadList();
                        } else {
                          searchedLoadList = myLoadList;
                          setState(() {});
                        }
                      },
                      style: TextStyle(
                          color: black,
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
                    )),
                Expanded(
                  flex: 4,
                  child: Container(),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            loading
                ? Expanded(child: const OnGoingLoadingWidgets())
                : searchedLoadList.isEmpty
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
                    : Expanded(
                        child: RefreshIndicator(
                            color: lightNavyBlue,
                            onRefresh: () {
                              setState(() {
                                myLoadList.clear();
                                loading = true;
                              });
                              return getDataByPostLoadId(0);
                            },
                            child: (kIsWeb && Responsive.isDesktop(context))
                                ? Card(
                                    margin: EdgeInsets.only(bottom: 5),
                                    shadowColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    elevation: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LoadsTableHeader(
                                            loadingStatus: 'MyLoads',
                                            screenWidth: MediaQuery.of(context)
                                                .size
                                                .width),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            primary: false,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            // physics: const AlwaysScrollableScrollPhysics (),
                                            scrollDirection: Axis.vertical,
                                            padding: EdgeInsets.only(
                                                bottom: space_15),
                                            controller: scrollController,
                                            itemCount: searchedLoadList.length,
                                            itemBuilder: (context, index) => (index ==
                                                    searchedLoadList
                                                        .length) //removed -1 here
                                                ? Visibility(
                                                    visible: bottomProgressLoad,
                                                    child:
                                                        const bottomProgressBarIndicatorWidget())
                                                : Row(children: [
                                                    MyLoadsCard(
                                                      loadDetailsScreenModel:
                                                          searchedLoadList[
                                                              index],
                                                    ),
                                                  ]),
                                            separatorBuilder:
                                                (context, index) => Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: space_15),
                                    controller: scrollController,
                                    itemCount: searchedLoadList.length,
                                    itemBuilder: (context, index) => (index ==
                                            searchedLoadList
                                                .length) //removed -1 here
                                        ? Visibility(
                                            visible: bottomProgressLoad,
                                            child:
                                                const bottomProgressBarIndicatorWidget())
                                        : MyLoadsCard(
                                            loadDetailsScreenModel:
                                                searchedLoadList[index],
                                          ),
                                  )),
                      )
          ],
        ));
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
      loadDetailsScreenModel.loadingPointState == json['loadingPointState'] ??
          'NA';
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
      loadDetailsScreenModel.scheduleLoadDate = json['loadingDate'] ?? 'NA';
      loadDetailsScreenModel.postLoadDate = json['postLoadDate'] ?? 'NA';
      loadDetailsScreenModel.status = json['status'];
      loadDetailsScreenModel.scheduleLoadTime = json['loadingTime'] ?? 'NA';
      loadDetailsScreenModel.publishMethod = json['publishMethod'] ?? 'NA';

      if (mounted) {
        setState(() {
          myLoadList.add(loadDetailsScreenModel);
          if (myLoadList.isNotEmpty) {
            getSearchLoadList();
          }
        });
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
        bottomProgressLoad = false;
      });
    }
  }

  getSearchLoadList() {
    String? searchedText = searchTextController.text;
    if (searchedText != null &&
        searchedText.isNotEmpty &&
        myLoadList.isNotEmpty) {
      if (searchedText.endsWith('')) {
        searchedText = removeTrailingSpaces(searchedText);
      }
      searchedText = searchedText.toLowerCase();
      searchedLoadList = [];
      for (int i = 0; i < myLoadList.length; i++) {
        String loadingPoint = myLoadList[i].loadingPoint ?? 'na';
        String loadingCity = myLoadList[i].loadingPointCity ?? 'na';
        String loadingState = myLoadList[i].loadingPointState ?? 'na';
        String loadingPoint2 = myLoadList[i].loadingPoint2 ?? 'na';
        String loadingCity2 = myLoadList[i].loadingPointCity2 ?? 'na';
        String loadingState2 = myLoadList[i].loadingPointState2 ?? 'na';
        String unloadingPoint = myLoadList[i].unloadingPoint ?? 'na';
        String unloadingCity = myLoadList[i].unloadingPointCity ?? 'na';
        String unloadingState = myLoadList[i].unloadingPointState ?? 'na';
        String unloadingPoint2 = myLoadList[i].unloadingPoint2 ?? 'na';
        String unloadingCity2 = myLoadList[i].unloadingPointCity2 ?? 'na';
        String unloadingState2 = myLoadList[i].unloadingPointState2 ?? 'na';
        String productType = myLoadList[i].productType ?? 'na';
        String truckType = myLoadList[i].truckType ?? 'na';
        String tyreNo = myLoadList[i].noOfTyres ?? 'na';
        String weight = myLoadList[i].weight ?? 'na';

        if (loadingPoint.toLowerCase().contains(searchedText) ||
            loadingCity.toLowerCase().contains(searchedText) ||
            loadingState.toLowerCase().contains(searchedText) ||
            loadingPoint2.toLowerCase().contains(searchedText) ||
            loadingCity2.toLowerCase().contains(searchedText) ||
            loadingState2.toLowerCase().contains(searchedText) ||
            unloadingPoint.toLowerCase().contains(searchedText) ||
            unloadingCity.toLowerCase().contains(searchedText) ||
            unloadingState.toLowerCase().contains(searchedText) ||
            unloadingPoint2.toLowerCase().contains(searchedText) ||
            unloadingCity2.toLowerCase().contains(searchedText) ||
            unloadingState2.toLowerCase().contains(searchedText) ||
            productType.toLowerCase().contains(searchedText) ||
            truckType.toLowerCase().contains(searchedText) ||
            tyreNo.toLowerCase().contains(searchedText) ||
            weight.toLowerCase().contains(searchedText)) {
          searchedLoadList.add(myLoadList[i]);
        }
      }
    } else {
      searchedLoadList = myLoadList;
    }
    setState(() {});
  }

  String removeTrailingSpaces(String input) {
    int endIndex = input.length - 1;

    while (endIndex >= 0 && input[endIndex] == ' ') {
      endIndex--;
    }

    return input.substring(0, endIndex + 1);
  }
}
