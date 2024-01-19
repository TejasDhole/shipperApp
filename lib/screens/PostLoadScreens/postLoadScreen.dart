import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/navigationScreen.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/controller/postLoadVariablesController.dart';
import '/providerClass/providerData.dart';
import '/screens/myLoadPages/deliveredScreen.dart';
import '/screens/myLoadPages/myLoadsScreen.dart';
import '/screens/myLoadPages/onGoingScreen.dart';
import '/widgets/OrderScreenNavigationBarButton.dart';
import '/widgets/buttons/postLoadButton.dart';
import 'package:provider/provider.dart';

class PostLoadScreen extends StatefulWidget {
  const PostLoadScreen({super.key});

  @override
  _PostLoadScreenState createState() => _PostLoadScreenState();
}

class _PostLoadScreenState extends State<PostLoadScreen> with TickerProviderStateMixin {
  //Page Controller
  late PageController pageController;
  PostLoadVariablesController postLoadVariables =
      Get.put(PostLoadVariablesController());
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialize tab controller
    tabController  = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: headerLightBlueColor,
      floatingActionButton: (kIsWeb &&
              (Responsive.isDesktop(context) || Responsive.isTablet(context)))
          ? null
          : PostButtonLoad(
              previousScreen: (kIsWeb)
                  ? HomeScreenWeb(
                      index: screens.indexOf(postLoadScreen),
                      selectedIndex: screens.indexOf(postLoadScreen),
                    )
                  : NavigationScreen()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                (Responsive.isDesktop(context) || Responsive.isTablet(context))
                    ? space_0
                    : space_4,
                space_4,
                space_4,
                space_2),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: space_2),
                  color: const Color.fromRGBO(245, 246, 250, 1),
                  child: Row(
                    children: [
                      Text(
                        'loads'.tr,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: kLiveasyColor,
                            fontWeight: FontWeight.w600,
                            fontSize: (Responsive.isMobile(context))
                                ? size_10
                                : size_15),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Visibility(
                            visible:
                                Responsive.isMobile(context) ? false : true,
                            child: PostButtonLoad(
                                previousScreen: (kIsWeb)
                                    ? HomeScreenWeb(
                                        index: screens.indexOf(postLoadScreen),
                                        selectedIndex:
                                            screens.indexOf(postLoadScreen),
                                      )
                                    : NavigationScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 5,
                      color: locationLineColor,
                    ),
                    TabBar(
                    controller: tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5, color: kLiveasyColor)
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat'
                    ),
                    labelColor: kLiveasyColor,
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat'
                    ),
                      unselectedLabelColor: locationLineColor,
                    onTap: (value) {
                      //handel tap events
                      if (pageController.page == value) {
                        providerData.updateClickSameUpperIndex(true);
                        if (pageController.page == 0) {
                          pageController
                              .nextPage(
                              duration: const Duration(milliseconds: 40),
                              curve: Curves.easeIn)
                              .whenComplete(() {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.easeIn);
                            providerData.updateClickSameUpperIndex(false);
                          });
                        } else {
                          pageController
                              .previousPage(
                              duration: const Duration(milliseconds: 40),
                              curve: Curves.easeIn)
                              .whenComplete(() {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.easeIn);
                            providerData.updateClickSameUpperIndex(false);
                          });
                        }
                        providerData.updateClickSameUpperIndex(false);
                      } else {
                        pageController.jumpToPage(value);
                        providerData.updateUpperNavigatorIndex(value);
                      }
                    },
                    tabs: [
                      Tab(text: 'my_loads'.tr),
                      Tab(text: 'on_going'.tr),
                      Tab(text: 'completed'.tr),
                    ],
                  )],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      if (value != providerData.upperNavigatorIndex && !providerData.clickSameUpperIndex) {
                        providerData.updateUpperNavigatorIndex(value);
                        tabController.animateTo(value);
                      }},
                    children: [
                      const MyLoadsScreen(),
                      const OngoingScreen(),
                      DeliveredScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
