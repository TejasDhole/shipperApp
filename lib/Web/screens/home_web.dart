// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/addLocationDrawerWidget.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/functions/shipperApis/isolatedShipperGetData.dart';
import '../../constants/screens.dart';
import '../../functions/shipperApis/runShipperApiPost.dart';
import '/constants/colors.dart';
import 'package:sizer/sizer.dart';
import '../logo.dart';

class HomeScreenWeb extends StatefulWidget {
  final Widget? visibleWidget;
  final int? index;
  final int? selectedIndex;

  const HomeScreenWeb(
      {Key? key, this.index, this.selectedIndex, this.visibleWidget})
      : super(key: key);

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  int _selectedIndex = 0;
  int _index = 0;
  late LinearGradient dashboardSelectedTabGradientColor,
      myLoadsSelectedTabGradientColor,
      invoiceSelectedTabGradientColor,
      accountSelectedTabGradientColor,
      liveasySelectedTabGradientColor,
      signoutSelectedTabGradientColor;

  late bool expandMode;
  late double widthOfSideBar;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  @override
  void initState() {
    super.initState();
    runShipperApiPost(
        emailId: FirebaseAuth.instance.currentUser!.email.toString());
    if (widget.index != null) {
      setState(() {
        _index = widget.index!;
        _selectedIndex = widget.selectedIndex!;
      });
    }
    expandMode = true;
    if (expandMode) {
      widthOfSideBar = 220;
    } else {
      widthOfSideBar = 110;
    }
    if (_selectedIndex == 0) {
      dashboardSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      dashboardSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    if (_selectedIndex == 1) {
      myLoadsSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      myLoadsSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    if (_selectedIndex == 2) {
      invoiceSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      invoiceSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }
    if (_selectedIndex == 3) {
      accountSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      accountSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }
    if (_selectedIndex == 4) {
      signoutSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      signoutSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    liveasySelectedTabGradientColor =
        const LinearGradient(colors: [white, white]);

    isolatedShipperGetData();
  }

  //TODO: This is the list for Navigation Rail List Destinations,This contains icons and it's labels

  //TODO : This is the list for Bottom Navigation Bar
  List<BottomNavigationBarItem> bottom_destinations = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.space_dashboard), label: "Dashboard"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_rounded), label: "My Loads"),
    //const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Invoice"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_outlined), label: "Account"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle_outlined), label: "Add User"),
  ];

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context) &&
        addLocationDrawerToggleController.drawerState.value == true) {
      addLocationDrawerToggleController.toggleDrawer(false);
    }
    return Obx(() {
      if (addLocationDrawerToggleController.drawerState.value == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldKey.currentState?.openEndDrawer();
        });
      } else {
        scaffoldKey.currentState?.closeEndDrawer();
      }
      return Scaffold(
        //TODO : Bottom Navigation Bar is only displayed when the screen size is in between sizes of mobile devices
        bottomNavigationBar: Responsive.isMobile(context)
            ? BottomNavigationBar(
                selectedItemColor: kLiveasyColor,
                unselectedItemColor: Colors.blueGrey,
                showUnselectedLabels: true,
                items: bottom_destinations,
                currentIndex: _selectedIndex,
                onTap: (updatedIndex) {
                  setState(() {
                    if (updatedIndex == 2 || updatedIndex == 3) {
                      _index = updatedIndex + 1;
                    } else {
                      _index = updatedIndex;
                    }
                    _selectedIndex = updatedIndex;
                  });
                },
              )
            : null,
        key: scaffoldKey,
        endDrawer: AddLocationDrawerWidget(context: context),
        appBar: AppBar(
          leading: null,
          backgroundColor: kLiveasyColor,
          title: Row(
            children: [
              TextButton(
                onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreenWeb()));
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      const LiveasyLogoImage(),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      const Text(
                        'Liveasy',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat Bold",
                            color: white),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: const SizedBox())
            ],
          ),
          actions: [
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _index = 5;
                  });
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _index = 7;
                  });
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SizedBox(
                width: 48,
                height: 40,
                child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _index =
                            screens.indexOf(accountVerificationStatusScreen);
                      });
                    },
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      color: white,
                    ),
                    label: const Text('')),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            //TODO : Similar to bottom navigation bar, Navigation rail is only displayed when it is not mobile screen
            Responsive.isMobile(context)
                ? const SizedBox(
                    width: 0.01,
                  )
                : Container(
                    child: Stack(
                      children: [
                        Row(children: [
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                            elevation: 5,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 100),
                              height: MediaQuery.of(context).size.height,
                              width: widthOfSideBar,
                              child: Column(
                                children: [
                                  SideExpandedItem(
                                      title: "Dashboard",
                                      icon: AssetImage(
                                          'assets/images/shipper_web_dashboard.png')),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SideExpandedItem(
                                      title: "My Loads",
                                      icon: AssetImage(
                                          'assets/images/shipper_web_my_loads.png')),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SideExpandedItem(
                                      title: "Invoice",
                                      icon: AssetImage(
                                          'assets/images/shipper_web_invoice.png')),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SideExpandedItem(
                                      title: "Team",
                                      icon: AssetImage(
                                          'assets/images/shipper_web_account.png')),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  SideExpandedItem(
                                      title: "Signout",
                                      icon: AssetImage(
                                          'assets/icons/signout.png')),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 30),
                                              child: SideExpandedItem(
                                                  title: "Liveasy",
                                                  icon: AssetImage(
                                                      'assets/images/shipper_liveasy_logo.png'))))),
                                ],
                              ),
                              color: white,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ]),
                        Positioned(
                          left: widthOfSideBar - 10,
                          top: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height) *
                              0.45,
                          height: 30,
                          width: 30,
                          child: Container(
                            //padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(50),
                                color: white),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (expandMode) {
                                    expandMode = false;
                                    widthOfSideBar = 110;
                                  } else {
                                    expandMode = true;
                                    widthOfSideBar = 220;
                                  }
                                });
                              },
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                  (expandMode)
                                      ? Icons.arrow_back_ios_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color: darkBlueTextColor,
                                  size: 20),
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        white),
                                side: MaterialStateProperty.all(
                                  const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                              ),
                              hoverColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            Expanded(
              child: Container(
                child: Center(
                  child:
                      (_index == 1000) ? widget.visibleWidget : screens[_index],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  InkWell SideExpandedItem({required String title, required AssetImage icon}) {
    if (_selectedIndex == 0) {
      dashboardSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      dashboardSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    if (_selectedIndex == 1) {
      myLoadsSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      myLoadsSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    if (_selectedIndex == 2) {
      invoiceSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      invoiceSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }
    if (_selectedIndex == 3) {
      accountSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      accountSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }
    if (_selectedIndex == 4) {
      signoutSelectedTabGradientColor =
          const LinearGradient(colors: [sideNavItemSelectedColor, transparent]);
    } else {
      signoutSelectedTabGradientColor =
          const LinearGradient(colors: [white, white]);
    }

    liveasySelectedTabGradientColor =
        const LinearGradient(colors: [white, white]);

    return InkWell(
        onTap: () {
          setState(() {
            if (title == "Dashboard") {
              dashboardSelectedTabGradientColor = const LinearGradient(
                  colors: [sideNavItemSelectedColor, transparent]);
              myLoadsSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              invoiceSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              accountSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              signoutSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              _selectedIndex = 0;
              _index = 0;
            } else if (title == "My Loads") {
              dashboardSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              myLoadsSelectedTabGradientColor = const LinearGradient(
                  colors: [sideNavItemSelectedColor, transparent]);
              invoiceSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              accountSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              signoutSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              _selectedIndex = 1;
              _index = 1;
            } else if (title == "Invoice") {
              dashboardSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              myLoadsSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              invoiceSelectedTabGradientColor = const LinearGradient(
                  colors: [sideNavItemSelectedColor, transparent]);
              accountSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              signoutSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              _selectedIndex = 2;
              _index = 2;
            } else if (title == "Team") {
              dashboardSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              myLoadsSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              invoiceSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              accountSelectedTabGradientColor = const LinearGradient(
                  colors: [sideNavItemSelectedColor, transparent]);
              signoutSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              _selectedIndex = 3;
              _index = 3;
            } else if (title == "Signout") {
              dashboardSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              myLoadsSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              invoiceSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              accountSelectedTabGradientColor =
                  const LinearGradient(colors: [white, white]);
              signoutSelectedTabGradientColor = const LinearGradient(
                  colors: [sideNavItemSelectedColor, transparent]);

              _selectedIndex = 4;
              _index = 4;
            }
          });
        },
        child: Container(
            height: 60,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                gradient: (title == "Liveasy")
                    ? liveasySelectedTabGradientColor
                    : (title == "Dashboard")
                        ? dashboardSelectedTabGradientColor
                        : (title == "My Loads")
                            ? myLoadsSelectedTabGradientColor
                            : (title == "Invoice")
                                ? invoiceSelectedTabGradientColor
                                : (title == "Team")
                                    ? accountSelectedTabGradientColor
                                    : signoutSelectedTabGradientColor),
            child: Row(
              children: [
                Image(image: icon, filterQuality: FilterQuality.high),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: expandMode,
                    child: (title == "Liveasy")
                        ? Text(
                            title,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat Bold",
                                color: darkBlueTextColor),
                          )
                        : Text(
                            title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                color: darkBlueTextColor),
                          ))
              ],
            )));
  }
}
