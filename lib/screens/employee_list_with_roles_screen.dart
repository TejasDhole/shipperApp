import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/Widgets/accountTableHeader.dart';
import 'package:shipper_app/Widgets/buttons/sendInviteEmployeeButton.dart';
import 'package:shipper_app/Widgets/teamSearchBar.dart';
import 'package:shipper_app/functions/shipperId_fromCompaniesDatabase.dart';
import 'package:shipper_app/models/company_users_model.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/add_user_screen.dart';
import '../Widgets/employee_card.dart';
import '../Widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import '../Widgets/loadingWidgets/onGoingLoadingWidgets.dart';
import '../constants/colors.dart';
import '../constants/fontSize.dart';
import '../constants/spaces.dart';

class EmployeeListRolesScreen extends StatefulWidget {
  const EmployeeListRolesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListRolesScreen> createState() =>
      _EmployeeListRolesScreenState();
}

class _EmployeeListRolesScreenState extends State<EmployeeListRolesScreen> {
  final List<CompanyUsers> users = [];
  List<CompanyUsers> filteredUsers = [];
  bool loading = true;
  bool isAllowed = false;
  bool bottomProgressLoad = false;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getCompanyEmployeeList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      // floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: loading
              ? const OnGoingLoadingWidgets()
              : users.isEmpty
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
                  : RefreshIndicator(
                      color: lightNavyBlue,
                      onRefresh: () {
                        setState(() {
                          users.clear();
                          loading = true;
                        });
                        return getCompanyEmployeeList();
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(color: isMobile ? lineDividerColor : teamBar),
                                height: isMobile ? screenHeight *  0.07 : screenHeight* 0.13,
                                width: screenWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Align(
                                    alignment: Responsive.isMobile(context) ?  Alignment.center : Alignment.centerLeft,
                                    child: Text('Team',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontSize: Responsive.isMobile(context) ? 18 : 30,
                                            color:  darkBlueTextColor)),
                                  ),
                                )),                       
                            isMobile ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Center(child: TeamSearchBar(searchController: searchController)), 
                                Container(decoration: const BoxDecoration(color: lineDividerColor),
                                height: screenHeight * 0.009,
                                margin: EdgeInsets.only(top: screenHeight * 0.012),),
                                const Align(alignment: Alignment.centerLeft, child: SendInviteButton()),
                              ]
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TeamSearchBar(searchController: searchController), 
                                const SendInviteButton(),                             
                              ],
                            ),
                            Visibility(child: AccountTableHeader(context), visible: Responsive.isMobile(context) ? false : true,),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: space_15),
                              itemCount: users.length,
                              itemBuilder: (context, index) => (index ==
                                      users.length) //removed -1 here
                                  ? Visibility(
                                      visible: bottomProgressLoad,
                                      child:
                                          const bottomProgressBarIndicatorWidget())
                                  : EmployeeCard(
                                      companyUsersModel: users[index],
                                    ),
                            ),
                          ]),
                    ),
        ),
      ),
    );
  }

  //TODO: This function is used get all the list of employees who are added to company database

  getCompanyEmployeeList() {
    if (mounted) {
      setState(() {
        bottomProgressLoad = true;
      });
    }
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref();
    late Map<dynamic, dynamic> values;
    ref
        .child(
            "companies/${shipperIdController.companyName.value.capitalizeFirst}/members")
        .get()
        .then((DataSnapshot snapshot) => {
              values = snapshot.value as Map<dynamic, dynamic>,
              values.forEach((key, value) {
                users.add(CompanyUsers(
                  uid: key,
                  role: value,
                ));
              }),
              setState(() {
                loading = false;
              }),
            });
  }
}
