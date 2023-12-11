import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/postLoadLocationWidgets/PostLoadMultipleLocationWidget.dart';
import 'package:shipper_app/responsive.dart';
import '../../constants/screens.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import 'package:get/get.dart';
import '/controller/shipperIdController.dart';
import '/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:provider/provider.dart';
import '/providerClass/providerData.dart';
import '/constants/spaces.dart';
import '/screens/PostLoadScreens/postloadnavigation.dart';

// ignore: must_be_immutable
class PostButtonLoad extends StatelessWidget {
  var previousScreen;
  ShipperIdController shipperIdController = Get.put(ShipperIdController());

  PostButtonLoad({super.key, required this.previousScreen});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return SizedBox(
      height: space_8,
      width: space_33,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: (Responsive.isMobile(context))
                ? BorderRadius.circular(50)
                : BorderRadius.circular(8),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(truckGreen),
        ),
        onPressed: () {
          providerData.resetPostLoadScreenOne();
          providerData.resetPostLoadFilters();
          providerData.resetPostLoadScreenMultiple();
          providerData.updateEditLoad(false, "");
          kIsWeb
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreenWeb(
                            visibleWidget: PostLoadNav(
                                setChild: postLoadMultipleLocationWidget(
                                    context, previousScreen),
                                index: 0),
                            index: 1000,
                            selectedIndex: screens.indexOf(postLoadScreen),
                          )))
              : Get.to(() => PostLoadNav(
                    setChild:
                        postLoadMultipleLocationWidget(context, previousScreen),
                    index: 0,
                  ));
        },
        child: Text(
          'postLoad'.tr,
          // AppLocalizations.of(context)!.postLoad,
          style: TextStyle(
            fontWeight: mediumBoldWeight,
            color: white,
            fontSize: size_8,
          ),
        ),
      ),
    );
  }
}
