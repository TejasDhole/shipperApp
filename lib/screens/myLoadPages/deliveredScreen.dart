import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/LoadsTableHeader.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/functions/bookingApi/getDeliveredDataWithPageNo.dart';
import '/models/deliveredCardModel.dart';
import '/widgets/deliveredCard.dart';
import '/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import '/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  _DeliveredScreenState createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  //for counting page numbers
  int i = 0;
  bool loading = false;
  bool DeliveredProgress = false;

  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  TextEditingController searchTextController = TextEditingController();
  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  List<DeliveredCardModel> modelList = [];
  List<DeliveredCardModel> searchedLoadList = [];

  ScrollController scrollController = ScrollController();

  getDataByPostLoadIdDelivered(int i) async {
    if (this.mounted) {
      setState(() {
        DeliveredProgress = true;
      });
    }
    var bookingDataListWithPagei = await getDeliveredDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
      if (modelList.isNotEmpty) {
        getSearchLoadList();
      }
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        DeliveredProgress = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getDataByPostLoadIdDelivered(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        getDataByPostLoadIdDelivered(i);
      }
    });
  }

  getSearchLoadList() {
    String? searchedText = searchTextController.text;
    if (searchedText != null &&
        searchedText.isNotEmpty &&
        modelList.isNotEmpty) {
      if (searchedText.endsWith('')) {
        searchedText = removeTrailingSpaces(searchedText);
      }
      searchedText = searchedText.toLowerCase();
      searchedLoadList = [];
      for (int i = 0; i < modelList.length; i++) {
        String loadingCity = modelList[i].loadingPointCity ?? 'na';
        String unloadingCity = modelList[i].unloadingPointCity ?? 'na';
        String truckNo = modelList[i].truckNo ?? 'na';
        String driverName = modelList[i].driverName ?? 'na';
        String companyName = modelList[i].companyName ?? 'na';
        String productType = modelList[i].productType ?? 'na';
        String truckType = modelList[i].truckType ?? 'na';
        String deviceId = modelList[i].deviceId.toString();

        if (loadingCity.toLowerCase().contains(searchedText) ||
            unloadingCity.toLowerCase().contains(searchedText) ||
            truckNo.toLowerCase().contains(searchedText) ||
            driverName.toLowerCase().contains(searchedText) ||
            companyName.toLowerCase().contains(searchedText) ||
            deviceId.toLowerCase().contains(searchedText) ||
            productType.toLowerCase().contains(searchedText) ||
            truckType.toLowerCase().contains(searchedText)) {
          searchedLoadList.add(modelList[i]);
        }
      }
    } else {
      searchedLoadList = modelList;
    }
    if (mounted) {
      setState(() {});
    }
  }

  String removeTrailingSpaces(String input) {
    int endIndex = input.length - 1;

    while (endIndex >= 0 && input[endIndex] == ' ') {
      endIndex--;
    }

    return input.substring(0, endIndex + 1);
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
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  flex: (Responsive.isMobile(context)) ? 8 : 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: white,
                      boxShadow: const [
                        BoxShadow(
                          color: lightGrey,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchTextController,
                      onChanged: (value) {
                        if (value.length > 2) {
                          getSearchLoadList();
                        } else {
                          searchedLoadList = modelList;
                          setState(() {});
                        }
                      },
                      style: TextStyle(
                          color: black,
                          fontFamily: 'Montserrat',
                          fontSize: size_8),
                      cursorColor: kLiveasyColor,
                      cursorWidth: 1,
                      mouseCursor: SystemMouseCursors.click,
                      decoration:  InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            bottom: 0, left: 5, right: 5, top: 15),
                        prefixIcon:
                        const Icon(Icons.search, color: grey, size: 25),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            fontSize: size_8,
                            fontFamily: "Montserrat",
                            color: grey,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
              Expanded(
                flex: (Responsive.isMobile(context)) ? 2 : 4,
                child: Container(),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          loading
              ? Expanded(child: const OnGoingLoadingWidgets())
              : searchedLoadList.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 153),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/EmptyLoad.png'),
                            height: 127,
                            width: 127,
                          ),
                          Text(
                            'stoppedLoad'.tr,
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
                            modelList.clear();
                            loading = true;
                          });
                          return getDataByPostLoadIdDelivered(0);
                        },
                        child: (kIsWeb && Responsive.isDesktop(context))
                            ? Card(
                                surfaceTintColor: transparent,
                                margin: EdgeInsets.only(bottom: 5),
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                elevation: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LoadsTableHeader(
                                        loadingStatus: 'On-Going',
                                        screenWidth:
                                            MediaQuery.of(context).size.width),
                                    Expanded(
                                      flex: 4,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        physics: const BouncingScrollPhysics(),
                                        // physics: const AlwaysScrollableScrollPhysics (),
                                        scrollDirection: Axis.vertical,
                                        padding:
                                            EdgeInsets.only(bottom: space_15),
                                        controller: scrollController,
                                        itemCount: searchedLoadList.length,
                                        itemBuilder: (context, index) => (index ==
                                            searchedLoadList
                                                    .length)
                                            ? Visibility(
                                                visible: DeliveredProgress,
                                                child:
                                                    bottomProgressBarIndicatorWidget())
                                            : Row(children: [
                                                DeliveredCard(
                                                  model: searchedLoadList[index],
                                                ),
                                              ]),
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                          thickness: 1,
                                          height: 0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: space_15),
                                controller: scrollController,
                                itemCount: searchedLoadList.length,
                                itemBuilder: (context, index) => (index ==
                                    searchedLoadList.length)
                                    ? Visibility(
                                        visible: DeliveredProgress,
                                        child:
                                            bottomProgressBarIndicatorWidget())
                                    : DeliveredCard(
                                        model: searchedLoadList[index],
                                      )),
                      ),
                    ),
        ],
      ),
    );
  }
} //class end
