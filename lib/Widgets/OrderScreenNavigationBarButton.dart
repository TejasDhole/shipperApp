import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/postLoadVariablesController.dart';
import 'package:shipper_app/screens/PostLoadScreens/postLoadScreen.dart';
import '/constants/colors.dart';
import '/constants/fontWeights.dart';
import '/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class OrderScreenNavigationBarButton extends StatelessWidget {
  final String text;
  final int value;
  final PageController pageController;

  PostLoadVariablesController postLoadVariables =
      Get.put(PostLoadVariablesController());

  OrderScreenNavigationBarButton(
      {required this.text, required this.value, required this.pageController});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Expanded(
      child: InkWell(
        hoverColor: transparent,
        onTap: () {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: providerData.upperNavigatorIndex == value
                      ? kLiveasyColor
                      : locationLineColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 5,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: providerData.upperNavigatorIndex == value
                    ? kLiveasyColor
                    : locationLineColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
