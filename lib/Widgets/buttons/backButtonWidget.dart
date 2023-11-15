import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/screens.dart';

class BackButtonWidget extends StatelessWidget {
  var previousPage;
  int? selectedIndex;

  BackButtonWidget({super.key, this.previousPage, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (previousPage != null) {
          if (kIsWeb) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreenWeb(
                    visibleWidget: previousPage,
                    selectedIndex: selectedIndex ?? 0,
                    index: 1000,
                  ),
                ));
          }else { 
            Navigator.pushReplacement(  
              context, 
              MaterialPageRoute(
                builder: (context) => previousPage,
              ));
          }
        } else {
          Get.back();
        }
      },
      child: Icon(Icons.arrow_back_ios_rounded),
    );
  }
}
