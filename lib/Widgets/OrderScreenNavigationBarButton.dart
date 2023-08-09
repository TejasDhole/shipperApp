import 'package:flutter/material.dart';
import 'package:shipper_app/screens/PostLoadScreens/postLoadScreen.dart';
import '/constants/colors.dart';
import '/constants/fontWeights.dart';
import '/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class OrderScreenNavigationBarButton extends StatelessWidget {
  final String text;
  final int value;
  final PageController pageController;

  OrderScreenNavigationBarButton(
      {required this.text, required this.value, required this.pageController});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return TextButton(
      onPressed: () {
        providerData.updateUpperNavigatorIndex(value);
        if (pageController.page == value) {
          if (pageController.page == 0) {
            pageController
                .nextPage(
                    duration: const Duration(milliseconds: 40),
                    curve: Curves.easeIn)
                .whenComplete(() => pageController.previousPage(
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeIn));
          } else {
            pageController
                .previousPage(
                    duration: const Duration(milliseconds: 40),
                    curve: Curves.easeIn)
                .whenComplete(() => pageController.nextPage(
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeIn));
          }
        } else {
          pageController.jumpToPage(value);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: providerData.upperNavigatorIndex == value
              ? loadingPointTextColor
              : locationLineColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
