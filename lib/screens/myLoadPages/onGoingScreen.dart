import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/trackAllScreen.dart';
import '../../Widgets/LoadsTableHeader.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';
import '/functions/bookingApi/getOngoingDataWithPageNo.dart';
import '/models/onGoingCardModel.dart';
import '/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import '/widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import '/widgets/onGoingCard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OngoingScreen extends StatefulWidget {
  const OngoingScreen({super.key});

  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextController = TextEditingController();
  List<OngoingCardModel> searchedLoadList = [];
  bool loading = true; //false
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  late String from;
  late String to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));

  //for counting page numbers
  int i = 0;

  bool OngoingProgress = true;

  final String bookingApiUrl = dotenv.get('bookingApiUrl');

  List<OngoingCardModel> modelList = [];

  getDataByPostLoadIdOnGoing(int i) async {
    if (this.mounted) {
      setState(() {
        OngoingProgress = true;
      });
    }
    var bookingDataListWithPagei = await getOngoingDataWithPageNo(i);
    for (var bookingData in bookingDataListWithPagei) {
      modelList.add(bookingData);
      if (modelList.isNotEmpty) {
        getSearchLoadList();
      }
    }

    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        loading = false;

        OngoingProgress = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    getDataByPostLoadIdOnGoing(i);
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        getDataByPostLoadIdOnGoing(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
        String deviceId = modelList[i].deviceId.toString() ?? 'na';

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
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        decoration: InputDecoration(
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
                Visibility(
                  visible: Responsive.isDesktop(context) ? true : false,
                  child: Expanded(
                    flex: (Responsive.isMobile(context)) ? 2 :4,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox(),),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreenWeb(
                                        visibleWidget: TrackAllScreen(),
                                        index: 1000,
                                        selectedIndex:
                                            screens.indexOf(postLoadScreen),
                                      )),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: darkBlueTextColor),
                                color: white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/icons/track.png'),
                                const SizedBox(width: 20,),
                                Text('Track All Loads',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: darkBlueTextColor)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                              'noOnGoingLoad'.tr,
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
                            return getDataByPostLoadIdOnGoing(0);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LoadsTableHeader(
                                          loadingStatus: 'On-Going',
                                          screenWidth: MediaQuery.of(context)
                                              .size
                                              .width),
                                      Expanded(
                                        flex: 4,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          primary: false,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          // physics: const AlwaysScrollableScrollPhysics (),
                                          scrollDirection: Axis.vertical,
                                          padding:
                                              EdgeInsets.only(bottom: space_15),
                                          controller: scrollController,
                                          itemCount: searchedLoadList.length,
                                          itemBuilder: (context, index) => (index ==
                                                  searchedLoadList
                                                      .length) //removed -1 here
                                              ? Visibility(
                                                  visible: OngoingProgress,
                                                  child:
                                                      bottomProgressBarIndicatorWidget())
                                              : Row(children: [
                                                  OngoingCard(
                                                    loadAllDataModel:
                                                        searchedLoadList[index],
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
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: space_15),
                                  itemCount: searchedLoadList.length,
                                  itemBuilder: (context, index) {
                                    return (index == searchedLoadList.length)
                                        ? Visibility(
                                            visible: OngoingProgress,
                                            child:
                                                bottomProgressBarIndicatorWidget())
                                        : (index < searchedLoadList.length)
                                            ? OngoingCard(
                                                loadAllDataModel:
                                                    searchedLoadList[index],
                                              )
                                            : Container();
                                  }),
                        ),
                      ),
          ],
        ));
  }
} //class end
