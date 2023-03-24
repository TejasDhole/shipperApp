import 'package:flutter/material.dart';
import '/constants/radius.dart';
import '/constants/spaces.dart';
import '/constants/colors.dart';
import '/controller/shipperIdController.dart';
import '/widgets/accountWidgets/accountDetailVerificationPending.dart';
import '/widgets/accountWidgets/accountDetailVerified.dart';
import '/widgets/accountWidgets/waitForReviewCard.dart';
import '/widgets/buttons/helpButton.dart';
import '/widgets/buyGpsLongWidget.dart';
import '/widgets/headingTextWidget.dart';
import 'package:get/get.dart';

class AccountVerificationStatusScreen extends StatelessWidget {
  const AccountVerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: space_2,
                      ),
                      HeadingTextWidget('my_account'.tr
                          // AppLocalizations.of(context)!.my_account
                          ),
                    ],
                  ),
                  HelpButtonWidget(),
                ],
              ),
              SizedBox(
                height: space_3,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: space_4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(space_1 + 3),
                  color: darkBlueColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: space_3),
                      child: CircleAvatar(
                        radius: radius_11,
                        backgroundColor: white,
                        child: Container(
                          height: space_8,
                          width: space_8,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/icons/defaultAccountIcon.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    shipperIdController.accountVerificationInProgress.value
                        ? AccountDetailVerificationPending(
                            mobileNum: shipperIdController.mobileNum.value,
                            name: shipperIdController.name.value,
                          )
                        : AccountDetailVerified(
                            //AccountDetailVerified(
                            mobileNum: shipperIdController.mobileNum.value,
                            name: shipperIdController.name.value,
                            companyName: shipperIdController.companyName.value,
                            address: shipperIdController.shipperLocation.value,
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: space_3,
              ),
              shipperIdController.accountVerificationInProgress.value
                  ? WaitForReviewCard()
                  : Container(),
              // shipperIdController.accountVerificationInProgress.value
              //     ? SizedBox(
              //         height: space_3,
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
