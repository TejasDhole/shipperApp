import 'package:flutter/material.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import '/Web/screens/login_phone_no.dart';
import '/responsive.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        mobile: HomeScreenWeb(),
        //tablet: LoginScreenWeb(),
        tablet: HomeScreenWeb(),
        //desktop: LoginScreen(),
        desktop: HomeScreenWeb(),
      ),
    );
  }
}
