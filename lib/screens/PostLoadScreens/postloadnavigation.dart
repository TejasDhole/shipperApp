import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import '/widgets/addPostLoadHeader.dart';
import '/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import '/screens/PostLoadScreens/PostLoadScreenMultiple.dart';

class PostLoadNav extends StatefulWidget {
  final Widget setChild; // bottom screen or child widget
  final int index; // index is required to display post load status or progress image
                    // index 0 for post load location; 1 for post load details and 2 for post load confirmation screen

  const PostLoadNav({Key? key, required this.setChild, required this.index})
      : super(key: key);

  @override
  State<PostLoadNav> createState() => _PostLoadNavState();
}

class _PostLoadNavState extends State<PostLoadNav> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: white,
            child: Column(
              children: [
                Container(
                  height:
                      (Responsive.isMobile(context)) ? null : Get.height * 0.1,
                  padding: EdgeInsets.fromLTRB(
                      space_4,
                      (Responsive.isMobile(context)) ? space_2 : space_4,
                      space_4,
                      space_2),
                  child: Row(
                    mainAxisAlignment: (Responsive.isDesktop(context) ||
                            Responsive.isTablet(context))
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        "Post Load",
                        style: TextStyle(
                          fontSize: (Responsive.isTablet(context))
                              ? size_13
                              : (Responsive.isDesktop(context))
                                  ? size_15
                                  : size_8,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: (Responsive.isMobile(context))
                              ? truckGreen
                              : kLiveasyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (Responsive.isDesktop(context) ||
                          Responsive.isTablet(context))
                      ? true
                      : false,
                  child: Container(
                    height: Get.height * 0.13,
                    child: Center(
                        child: Image.asset(
                      (widget.index == 0)
                          ? 'assets/images/load_location_details_progress_status.png'
                          : (widget.index == 1)
                              ? 'assets/images/load_details_progress_status.png'
                              : 'assets/images/load_confirmation_progress_status.png',
                      width: (Responsive.isTablet(context))
                          ? MediaQuery.of(context).size.width * 0.45
                          : 600,
                      filterQuality: FilterQuality.high,
                    )),
                  ),
                ),
                widget.setChild
              ],
            ),
          ),
        ),
      ),
    );
  }
}
