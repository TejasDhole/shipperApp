import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/controller/shipperIdController.dart';

import 'alertDialog/LogOutDialogue.dart';

class AccountMenuButton extends StatefulWidget {
  final List<Widget> screens;
  final Widget accountVerificationStatusScreen;
  final Function(int) updateIndex;

  const AccountMenuButton({
    Key? key,
    required this.screens,
    required this.accountVerificationStatusScreen,
    required this.updateIndex,
  }) : super(key: key);

  @override
  State<AccountMenuButton> createState() => _AccountMenuButtonState();
}

class _AccountMenuButtonState extends State<AccountMenuButton> {
  ShipperIdController shipperIdController = Get.put(ShipperIdController());
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        // This is where you show the popup menu
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(
              100.0, 50, 10, 100.0), // Adjust the position as needed
          items: [
            PopupMenuItem(
              child: ListTile(
                  title: Center(
                    child: Text(
                      shipperIdController.name.value,
                      style: TextStyle(
                        color: black,
                        fontWeight: mediumBoldWeight,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: Text(
                      shipperIdController.role.value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: normalWeight,
                        color: subtitleGrey,
                      ),
                    ),
                  ),
                  horizontalTitleGap: 0.0,
                  onTap: null),
            ),
            PopupMenuItem(
              child: ListTile(
                leading:
                    const Icon(Icons.account_circle_outlined, color: black),
                title: Text(
                  'My profile',
                  style: TextStyle(
                    color: black,
                    fontWeight: normalWeight,
                    fontSize: 18,
                  ),
                ),
                horizontalTitleGap: 0.0,
                onTap: () {
                  widget.updateIndex(widget.screens
                      .indexOf(widget.accountVerificationStatusScreen));
                  Navigator.of(context).pop();
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: black),
                title: Text(
                  'Help',
                  style: TextStyle(
                    color: black,
                    fontWeight: normalWeight,
                    fontSize: 18,
                  ),
                ),
                horizontalTitleGap: 0.0,
                onTap: () {
                  // Handle Help action
                  Navigator.of(context).pop();
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.logout, color: black),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: black,
                    fontWeight: normalWeight,
                    fontSize: 18,
                  ),
                ),
                horizontalTitleGap: 0.0,
                onTap: () async {
                  // Handle logout
                  Navigator.of(context).pop();
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LogoutDialogue();
                    },
                  );
                  // Logout action is handled within the dialog
                },
              ),
            ),
          ],
        );
      },
      icon: const Icon(
        Icons.account_circle_rounded,
        color: white,
      ),
      label: const Text(''),
    );
  }
}
