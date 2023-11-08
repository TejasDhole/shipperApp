import 'package:flutter/material.dart';
import 'package:shipper_app/Widgets/postLoadLocationWidgets/PostLoadMultipleLocationWidget.dart';
import 'package:shipper_app/screens/Invoice_screen.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:shipper_app/screens/accountScreens/account_details.dart';
import 'package:shipper_app/screens/employee_list_with_roles_screen.dart';
import 'package:shipper_app/screens/PostLoadScreens/postloadnavigation.dart';
import 'package:shipper_app/screens/facilities.dart';
import '../Web/screens/web_dashboard.dart';
import '../Widgets/accountVerification/accountPageUtil.dart';
import '../Widgets/alertDialog/LogOutDialogue.dart';
import '../screens/HelpScreen.dart';
import '../screens/PostLoadScreens/postLoadScreen.dart';
import '../screens/add_user_screen.dart';

//TODO : At first add screens like this,and add that to list.
//TODO: So that we can use home screen as base screen and update the right side of screen accordingly
const webDashBoard = WebDashBoard();
const invoiceScreen = InvoiceScreen();
const contactUs = Center(child: Text('contact us'));
const postLoadScreen = PostLoadScreen();
var postLoadNav = PostLoadNav(
  setChild: Container(),
  index: 0,
);
const addUser = AddUser();
const accountVerificationStatusScreen = AccountScreen();
const helpScreen = HelpScreen();
final accountPageUtil = AccountPageUtil();
const facilities = Facilities();
const logoutDialogue = LogoutDialogue();
const employeeListScreen = EmployeeListRolesScreen();
const postLoadScreenTwo = PostLoadScreenTwo();


//TODO : This is the list of the screens, Navigated to these when user selects anything,we are maintaining home screen as base screen.
//TODO : All the variables above initialized must be added to this list.
List<Widget> screens = [
  webDashBoard,
  postLoadScreen,
  invoiceScreen,
  employeeListScreen,
  facilities,
  logoutDialogue,
  helpScreen,
  contactUs,


  //
  postLoadNav,
  accountVerificationStatusScreen,
  addUser,
  postLoadScreenTwo,
  //
];
