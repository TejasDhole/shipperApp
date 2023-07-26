// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/functions/shipperApis/isolatedShipperGetData.dart';
import '../../constants/screens.dart';
import '../../functions/shipperApis/runShipperApiPost.dart';
import '/constants/colors.dart';
import 'package:sizer/sizer.dart';
import '../logo.dart';

class HomeScreenWeb extends StatefulWidget {
  final int? index;
  final int? selectedIndex;
  const HomeScreenWeb({Key? key, this.index, this.selectedIndex})
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
      liveasySelectedTabGradientColor;
  late bool expandMode;
  late double widthOfSideBar;

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
    if(_selectedIndex==0){
      dashboardSelectedTabGradientColor = LinearGradient(colors: [
        Color.fromRGBO(9, 183, 120, 0.3),
        Color.fromRGBO(241, 240, 240, 0)
      ]);
    }
    else{
      dashboardSelectedTabGradientColor = LinearGradient(colors: [Colors.white, Colors.white]);
    }

    if(_selectedIndex == 1){
      myLoadsSelectedTabGradientColor = LinearGradient(colors: [
        Color.fromRGBO(9, 183, 120, 0.3),
        Color.fromRGBO(241, 240, 240, 0)
      ]);
    }
    else{
      myLoadsSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }

    if(_selectedIndex == 2){
      invoiceSelectedTabGradientColor =
          LinearGradient(colors: [
            Color.fromRGBO(9, 183, 120, 0.3),
            Color.fromRGBO(241, 240, 240, 0)
          ]);
    }
    else{
      invoiceSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }
    if(_selectedIndex ==3){
      accountSelectedTabGradientColor =
          LinearGradient(colors: [
            Color.fromRGBO(9, 183, 120, 0.3),
            Color.fromRGBO(241, 240, 240, 0)
          ]);
    }
    else{
      accountSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }


    liveasySelectedTabGradientColor =
        LinearGradient(colors: [Colors.white, Colors.white]);

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
      appBar: AppBar(
        backgroundColor: kLiveasyColor,
        title: TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreenWeb()));
          },
          child: SizedBox(
            width: Responsive.isMobile(context) ? 10.w : 9.w,
            child: Row(
              children: [
                const LiveasyLogoImage(),
                SizedBox(
                  width: 0.5.w,
                ),
                Text(
                  'Liveasy',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.isMobile(context) ? 4.5.sp : 5.sp,
                      color: Colors.white),
                ),
              ],
            ),
          ),
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
                color: Colors.white,
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
                color: Colors.white,
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
                      _index = screens.indexOf(accountVerificationStatusScreen);
                    });
                  },
                  icon: const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero)),
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 100),
                            height: MediaQuery.of(context).size.height,
                            width: widthOfSideBar,
                            child: Column(
                              children: [
                                SideExpandedItem(
                                    title: "Dashboard",
                                    icon: AssetImage(
                                        'assets/images/shipper_web_dashboard.png')),
                                SizedBox(
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
                                    title: "Account",
                                    icon: AssetImage(
                                        'assets/images/shipper_web_account.png')),
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
                            color: Colors.white,
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
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
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
                                color: Color.fromRGBO(21, 41, 104, 1),
                                size: 20),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                              side: MaterialStateProperty.all(
                                BorderSide(width: 1, color: Colors.black),
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
                child: screens[_index],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell SideExpandedItem({required String title, required AssetImage icon}) {

    if(_selectedIndex==0){
      dashboardSelectedTabGradientColor = LinearGradient(colors: [
        Color.fromRGBO(9, 183, 120, 0.3),
        Color.fromRGBO(241, 240, 240, 0)
      ]);
    }
    else{
      dashboardSelectedTabGradientColor = LinearGradient(colors: [Colors.white, Colors.white]);
    }

    if(_selectedIndex == 1){
      myLoadsSelectedTabGradientColor = LinearGradient(colors: [
        Color.fromRGBO(9, 183, 120, 0.3),
        Color.fromRGBO(241, 240, 240, 0)
      ]);
    }
    else{
      myLoadsSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }

    if(_selectedIndex == 2){
      invoiceSelectedTabGradientColor =
          LinearGradient(colors: [
            Color.fromRGBO(9, 183, 120, 0.3),
            Color.fromRGBO(241, 240, 240, 0)
          ]);
    }
    else{
      invoiceSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }
    if(_selectedIndex ==3){
      accountSelectedTabGradientColor =
          LinearGradient(colors: [
            Color.fromRGBO(9, 183, 120, 0.3),
            Color.fromRGBO(241, 240, 240, 0)
          ]);
    }
    else{
      accountSelectedTabGradientColor =
          LinearGradient(colors: [Colors.white, Colors.white]);
    }


    liveasySelectedTabGradientColor =
        LinearGradient(colors: [Colors.white, Colors.white]);

    return InkWell(
        onTap: () {
          setState(() {
            if (title == "Dashboard") {
              dashboardSelectedTabGradientColor = LinearGradient(colors: [
                Color.fromRGBO(9, 183, 120, 0.3),
                Color.fromRGBO(241, 240, 240, 0)
              ]);
              myLoadsSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              invoiceSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              accountSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              _selectedIndex = 0;
              _index = 0;
            } else if (title == "My Loads") {
              dashboardSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              myLoadsSelectedTabGradientColor = LinearGradient(colors: [
                Color.fromRGBO(9, 183, 120, 0.3),
                Color.fromRGBO(241, 240, 240, 0)
              ]);
              invoiceSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              accountSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              _selectedIndex = 1;
              _index = 1;
            } else if (title == "Invoice") {
              dashboardSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              myLoadsSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              invoiceSelectedTabGradientColor = LinearGradient(colors: [
                Color.fromRGBO(9, 183, 120, 0.3),
                Color.fromRGBO(241, 240, 240, 0)
              ]);
              accountSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              _selectedIndex = 2;
              _index = 2;
            } else if (title == "Account") {
              dashboardSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              myLoadsSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              invoiceSelectedTabGradientColor =
                  LinearGradient(colors: [Colors.white, Colors.white]);
              accountSelectedTabGradientColor = LinearGradient(colors: [
                Color.fromRGBO(9, 183, 120, 0.3),
                Color.fromRGBO(241, 240, 240, 0)
              ]);
              _selectedIndex = 3;
              _index = 3;
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
                                : accountSelectedTabGradientColor),
            child: Row(
              children: [
                Image(image: icon, filterQuality: FilterQuality.high),
                SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: expandMode,
                    child: (title == "Liveasy")
                        ? Text(
                            title,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat Bold",
                                color: Color.fromRGBO(21, 41, 104, 1)),
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                color: Color.fromRGBO(21, 41, 104, 1)),
                          ))
              ],
            )));
  }
}

// List<NavigationRailDestination> destinations = [
//   const NavigationRailDestination(
//     icon: Icon(Icons.space_dashboard),
//     label: Text("Dashboard"),
//   ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.inventory_2_rounded),
//     label: Text("My Loads"),
//   ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.receipt_long),
//     label: Text("Invoice"),
//   ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.person_outline_outlined),
//     label: Text("Account"),
//   ),
//   // const NavigationRailDestination(
//   //   icon: Icon(Icons.supervised_user_circle_outlined),
//   //   label: Text("Add User"),
//   // ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.support_agent_outlined),
//     label: Text("Help and Support"),
//   ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.phone_in_talk_outlined),
//     label: Text("Contact Us"),
//   ),
//   const NavigationRailDestination(
//     icon: Icon(Icons.logout_outlined),
//     label: Text("Logout"),
//   ),
// ];

// NavigationRail(
// extended: Responsive.isDesktop(context) ? true : false,
// selectedIconTheme: const IconThemeData(color: kLiveasyColor),
// unselectedLabelTextStyle: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 3.6.sp,
// color: Colors.black),
// selectedLabelTextStyle: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 3.9.sp,
// color: kLiveasyColor),
// indicatorColor: const Color(0xFFC4C4C4),
// labelType: Responsive.isDesktop(context)
// ? NavigationRailLabelType.none
//     : NavigationRailLabelType.all,
// destinations: destinations,
// selectedIndex: _selectedIndex,
// onDestinationSelected: (index) {
// setState(() {
// _selectedIndex = index;
// _index = index;
// });
// },
// elevation: 20,
// ),
// const VerticalDivider(
// thickness: 1,
// width: 1,
// ),
