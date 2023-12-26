// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/addLocationDrawerWidget.dart';
import 'package:shipper_app/Widgets/alertDialog/LogOutDialogue.dart';
import 'package:shipper_app/constants/shipper_nav_icons.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/functions/shipperApis/isolatedShipperGetData.dart';
import '../../constants/screens.dart';
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
  late Color dashboardSelectedTabGradientColor,
      myLoadsSelectedTabGradientColor,
      ewayBillsSelectedTabGradientColor,
      invoiceSelectedTabGradientColor,
      accountSelectedTabGradientColor,
      liveasySelectedTabGradientColor,
      facilitySelectedTabGradientColor,
      signoutSelectedTabGradientColor;

  late bool expandMode;
  late double widthOfSideBar;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  @override
  void initState() {
    super.initState();
    isolatedShipperGetData();

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
      dashboardSelectedTabGradientColor = kLiveasyColor;
    } else {
      dashboardSelectedTabGradientColor = white;
    }

    if (_selectedIndex == 1) {
      myLoadsSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      myLoadsSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 2) {
      ewayBillsSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      ewayBillsSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 3) {
      invoiceSelectedTabGradientColor =
         kLiveasyColor;
    } else {
      invoiceSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 4) {
      accountSelectedTabGradientColor =
         kLiveasyColor;
    } else {
      accountSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 5) {
      facilitySelectedTabGradientColor =
          kLiveasyColor;
    } else {
      facilitySelectedTabGradientColor =
         white;
    }
    if (_selectedIndex == 6) {
      signoutSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      signoutSelectedTabGradientColor =
          white;
    }

    liveasySelectedTabGradientColor =
        white;
  }

  //TODO: This is the list for Navigation Rail List Destinations,This contains icons and it's labels

  //TODO : This is the list for Bottom Navigation Bar
  List<BottomNavigationBarItem> bottom_destinations = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.space_dashboard), label: "Control Tower"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_rounded), label: "My Loads"),
    const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Eway Bills"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_outlined), label: "Account"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle_outlined), label: "Add User"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.location_on), label: "Facility"),
  ];

  refresh() {
    setState(() {});
  }

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
        endDrawer: AddLocationDrawerWidget(
          context: context,
          refreshParent: refresh,
        ),
        onEndDrawerChanged: (isOpened) {
          if (isOpened == false) {
            addLocationDrawerToggleController.toggleDrawer(false);
          }
        },
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
                            surfaceTintColor: transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                            elevation: 5,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 70),
                              height: MediaQuery.of(context).size.height,
                              width: widthOfSideBar,
                              color: white,
                              child: Column(
                                children: [
                                  SideExpandedItem(
                                      title: "Control Tower",
                                      iconSize: 18,
                                      icon: ShipperNav.control_tower,
                                      position: 0),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "My Loads",
                                      iconSize: 18,
                                      icon: ShipperNav.loads,
                                      position: 1),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "Eway Bills",
                                      iconSize: 18,
                                      icon: ShipperNav.eway_bill,
                                      position: 2),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "Invoice",
                                      iconSize: 18,
                                      icon: ShipperNav.invoice,
                                      position: 3),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "Team",
                                      iconSize: 18,
                                      icon : ShipperNav.team,
                                      position: 4),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SideExpandedItem(
                                      title: "Facility",
                                      iconSize: 18,
                                      icon: ShipperNav.facility,
                                      position: 5),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                  SideExpandedItem(
                                      title: "Signout",
                                      iconSize: 23,
                                      icon: Icons.logout_outlined,
                                      position: 6),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 30),
                                              child: SideExpandedItem(
                                                  title: "Liveasy",
                                                  iconSize: 23,
                                                  icon: ShipperNav.liveasy_logo, position: 999)))),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: headerLightBlueColor,
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

  InkWell SideExpandedItem({required String title, required IconData icon, required int position, required double iconSize}) {
    if (_selectedIndex == 0) {
      dashboardSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      dashboardSelectedTabGradientColor =
          white;
    }

    if (_selectedIndex == 1) {
      myLoadsSelectedTabGradientColor =
         kLiveasyColor;
    } else {
      myLoadsSelectedTabGradientColor =
          white;
    }

     if (_selectedIndex == 2) {
      ewayBillsSelectedTabGradientColor =
         kLiveasyColor;
    } else {
      ewayBillsSelectedTabGradientColor  =
          white;
    }

    if (_selectedIndex == 3) {
      invoiceSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      invoiceSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 4) {
      accountSelectedTabGradientColor =
          kLiveasyColor;
    } else {
      accountSelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 5) {
      facilitySelectedTabGradientColor =
          kLiveasyColor;
    } else {
      facilitySelectedTabGradientColor =
          white;
    }
    if (_selectedIndex == 6) {
      signoutSelectedTabGradientColor =
         kLiveasyColor;
    } else {
      signoutSelectedTabGradientColor =
          white;
    }

    liveasySelectedTabGradientColor =
        white;

    return InkWell(
        onTap: () {
          setState(() {
            if (title == "Control Tower") {
              dashboardSelectedTabGradientColor = kLiveasyColor;
              myLoadsSelectedTabGradientColor =
                  white;
              ewayBillsSelectedTabGradientColor =
                 white;
              invoiceSelectedTabGradientColor =
                 white;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor =
                  white;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 0;
              _index = 0;
            } else if (title == "My Loads") {
              dashboardSelectedTabGradientColor =
                 white;
              myLoadsSelectedTabGradientColor = kLiveasyColor;
              ewayBillsSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor =
                  white;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor =
                 white;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 1;
              _index = 1;
            } else if (title == "Eway Bills") {
              dashboardSelectedTabGradientColor =
                 white;
              myLoadsSelectedTabGradientColor = white;
              ewayBillsSelectedTabGradientColor = kLiveasyColor;
              invoiceSelectedTabGradientColor =
                  white;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor =
                 white;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 2;
              _index = 2;
            } 
            else if (title == "Invoice") {
              dashboardSelectedTabGradientColor =
                  white;
              myLoadsSelectedTabGradientColor =
                  white;
              ewayBillsSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor = kLiveasyColor;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor =
                  white;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 3;
              _index = 3;
            } else if (title == "Team") {
              dashboardSelectedTabGradientColor =
                  white;
              myLoadsSelectedTabGradientColor =
                  white;
              ewayBillsSelectedTabGradientColor = white;    
              invoiceSelectedTabGradientColor =
                  white;
              accountSelectedTabGradientColor = kLiveasyColor;
              facilitySelectedTabGradientColor =
                  white;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 4;
              _index = 4;
            } else if (title == "Facility") {
              dashboardSelectedTabGradientColor =
                  white;
              myLoadsSelectedTabGradientColor =
                  white;
              ewayBillsSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor =
                  white;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor = kLiveasyColor;
              signoutSelectedTabGradientColor =
                  white;
              _selectedIndex = 5;
              _index = 5;
            } else if (title == "Signout") {
              dashboardSelectedTabGradientColor =
                  white;
              myLoadsSelectedTabGradientColor =
                  white;
              ewayBillsSelectedTabGradientColor = white;
              invoiceSelectedTabGradientColor =
                  white;
              accountSelectedTabGradientColor =
                  white;
              facilitySelectedTabGradientColor =
                  white;
              signoutSelectedTabGradientColor = kLiveasyColor;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LogoutDialogue();
                },
              );
            }
          });
        },
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 15, top:15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                color: (title == "Liveasy")
                    ? liveasySelectedTabGradientColor
                    : (title == "Control Tower")
                        ? dashboardSelectedTabGradientColor
                        : (title == "My Loads")
                            ? myLoadsSelectedTabGradientColor
                            :(title == "Eway Bills")
                            ? ewayBillsSelectedTabGradientColor
                            : (title == "Invoice")
                                ? invoiceSelectedTabGradientColor
                                : (title == "Team")
                                    ? accountSelectedTabGradientColor
                                    : (title == "Facility")
                                        ? facilitySelectedTabGradientColor
                                        : signoutSelectedTabGradientColor),
            child: Row(
              children: [
                Icon(icon, size: iconSize, color : position == _selectedIndex ? white : darkBlueColor),
                 const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: expandMode,
                    child: (title == "Liveasy")
                        ? Text(
                            title,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat Bold",
                                color: position == _selectedIndex ? white : darkBlueColor),
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                color: (position ==_selectedIndex) ? white : darkBlueColor),
                          ))
              ],
            )));
  }
}
