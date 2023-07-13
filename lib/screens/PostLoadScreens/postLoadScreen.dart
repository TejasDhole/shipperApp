import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shipper_app/responsive.dart';
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
  PageController pageController = PageController(initialPage: 0);
  PostLoadVariablesController postLoadVariables =
      Get.put(PostLoadVariablesController());
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: (kIsWeb && (Responsive.isDesktop(context) || Responsive.isTablet(context)))?null:PostButtonLoad(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
          child: Column(
            children: [
              (kIsWeb && (Responsive.isDesktop(context) || Responsive.isTablet(context)))?
                  Container(
                    padding: EdgeInsets.only(bottom: space_2),
                    color: Color.fromRGBO(245, 246, 250, 1),
                    child: Row(children: [ Text('loads'.tr, style: TextStyle(fontFamily: 'Montserrat', color: kLiveasyColor, fontWeight: FontWeight.w600,fontSize: 30 ),),
                    Expanded(child: Align(alignment: Alignment.centerRight,child: PostButtonLoad(),)),
                    ],),
                  ):
                  Header(
                  reset: false,
                  text: 'loads'.tr,
                  // AppLocalizations.of(context)!.loads,
                  backButton: false),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                height: 5,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.only(top: 5,bottom: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color.fromRGBO(21, 41, 104, 1), Color.fromRGBO(9, 183, 120, 1)])
                ),
              ),
              Stack(
                // alignment: Alignment.center,
                alignment: Alignment.bottomCenter,
                children: [
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
                  // Positioned.fill(
                  //   top: 550,
                  //   child: Align(
                  //       alignment: Alignment.center, child: PostButtonLoad()),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
