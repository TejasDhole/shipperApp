import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';

class CustomRole extends StatefulWidget {
  final String selectedRole;
  final ValueChanged<String> roleChanged;

  const CustomRole(
      {Key? key, required this.selectedRole, required this.roleChanged})
      : super(key: key);

  @override
  _CustomRoleState createState() => _CustomRoleState();
}

class _CustomRoleState extends State<CustomRole> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 250,
      decoration: BoxDecoration(
        border: Border.all(color: greyShade),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          alignment: Alignment.center,
          isExpanded: true,
          value: widget.selectedRole,
          items: _dropDownItem(),
          onChanged: (value) {
            widget.roleChanged(value!);
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> roles = ['employee', 'owner'];
    return roles
        .map((value) => DropdownMenuItem(
            value: value,
            child: Center(
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: darkBlueTextColor, fontWeight: FontWeight.w500)),
            )))
        .toList();
  }
}
