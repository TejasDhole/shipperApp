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
    return Container(
        width: Responsive.isMobile(context)
            ? screenWidth * 0.85
            : screenWidth * 0.3,
        alignment: Alignment.centerLeft,
        padding: Responsive.isMobile(context) ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
        child: TextField(
          controller: widget.searchController,
          decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: searchBar),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: greyShade),
                  borderRadius: BorderRadius.all(Radius.zero)),
                  prefixIconColor: Colors.black,
              prefixIcon: Responsive.isMobile(context)
                  ? const Icon(Icons.arrow_back)
                  : null,
              suffixIcon: const Icon(Icons.search)),
          onChanged: (value) {
            // Handle search functionality here
            // You can filter the users list based on the search value
            //filterUsers(value);
          },
        ));
  }
}
