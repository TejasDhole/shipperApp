import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/responsive.dart';

class TeamSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  const TeamSearchBar({Key? key, required this.searchController})
      : super(key: key);

  @override
  State<TeamSearchBar> createState() => _TeamSearchBarState();
}

class _TeamSearchBarState extends State<TeamSearchBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    return Container(
        width: Responsive.isMobile(context)
            ? screenWidth * 0.85
            : screenWidth * 0.3,
        height: screenHeight * 0.07,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: screenHeight * 0.06, left: screenWidth * 0.015),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: widget.searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: 'Search by name, email',
            hintStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: grey2,
                fontSize: isMobile ? screenHeight * 0.027 : screenWidth * 0.012),
            border: InputBorder.none,
            prefixIconColor: const Color.fromARGB(255, 109, 109, 109),
            prefixIcon: Responsive.isMobile(context)
                ? const Icon(Icons.arrow_back)
                : Icon(Icons.search),
          ),
          onChanged: (value) {
            // Handle search functionality here
            // You can filter the users list based on the search value
            //filterUsers(value);
          },
        ));
  }
}
