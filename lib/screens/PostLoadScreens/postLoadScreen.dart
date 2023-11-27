import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/PublishMethodBidSearchTextFieldWidget.dart';
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
import '/widgets/Header.dart';
import '/widgets/OrderScreenNavigationBarButton.dart';
import '/widgets/buttons/postLoadButton.dart';
import 'package:provider/provider.dart';

class PostLoadScreen extends StatefulWidget {
  const PostLoadScreen({super.key});

  @override
  _PostLoadScreenState createState() => _PostLoadScreenState();
}

class _PostLoadScreenState extends State<PostLoadScreen> {
  //Page Controller
  late PageController pageController;
  PostLoadVariablesController postLoadVariables =
      Get.put(PostLoadVariablesController());

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: backgroundColor,
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
                  color: Color.fromRGBO(245, 246, 250, 1),
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
                Container(
                  child: Row(
                    children: [
                      OrderScreenNavigationBarButton(
                          text: 'my_loads'.tr,
                          // AppLocalizations.of(context)!.my_loads,
                          value: 0,
                          pageController: pageController),
                      OrderScreenNavigationBarButton(
                          text: 'on_going'.tr,
                          // AppLocalizations.of(context)!.on_going,
                          value: 1,
                          pageController: pageController),
                      OrderScreenNavigationBarButton(
                          text: 'completed'.tr,
                          // AppLocalizations.of(context)!.completed,
                          value: 2,
                          pageController: pageController)
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        providerData.updateUpperNavigatorIndex(value);
                      });
                    },
                    children: [
                      MyLoadsScreen(),
                      OngoingScreen(),
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
