import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shipper_app/Web/screens/login.dart';
import 'package:shipper_app/main_screen.dart';
import 'package:shipper_app/screens/SplashScreenToHomePage.dart';
import 'package:shipper_app/screens/SplashScreenToLogin.dart';
import 'package:sizer/sizer.dart';
import 'constants/radius.dart';
import 'firebase_options.dart';
import 'providerClass/providerData.dart';
import 'package:get/get.dart';
import 'screens/errorScreen.dart';
import 'screens/noInternetScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity/connectivity.dart';
import 'language/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

var firebase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  firebase = kIsWeb
      ? await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        )
      : Firebase.initializeApp();
  await dotenv.load();
  await GetStorage.init();
  await GetStorage.init('ShipperIDStorage');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _connectionStatus = "Unknown";
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isDisconnected = false;
  GetStorage sidstorage = GetStorage('ShipperIDStorage');
  String? shipperId;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    setState(() {});
    shipperId = sidstorage.read("shipperId");
    //print(firebase);
    getSharedPrefs();
    if (!kIsWeb) {
      checkConnection();
      connectivityChecker();
    }
  }

  getSharedPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  void checkConnection() {
    configOneSignel();
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (isDisconnected) {
          isDisconnected = false;
          connectivityChecker();
          Get.back();
        }
      } else {
        if (!isDisconnected) {
          isDisconnected = true;
          Get.defaultDialog(
              barrierDismissible: false,
              content: NoInternetConnection.noInternetDialogue(),
              onWillPop: () async => false,
              title: "\nNo Internet",
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ));
        } else {
          connectivityChecker();
        }
      }
    });
  }

  Future<void> connectivityChecker() async {
    print("Checking internet...");
    try {
      await InternetAddress.lookup('google.com');
    } on SocketException catch (_) {
      isDisconnected = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.defaultDialog(
            barrierDismissible: false,
            content: NoInternetConnection.noInternetDialogue(),
            onWillPop: () async => false,
            title: "\nNo Internet",
            titleStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ));
      });
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void configOneSignel() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    String oneSignalAppId = dotenv.get('oneSignalAppId').toString();
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
      child: ChangeNotifierProvider<ProviderData>(
          create: (context) => ProviderData(),
          builder: (context, child) {
            return Sizer(builder: (context, orientation, deviceType) {
              return kIsWeb
                  ? GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      builder: EasyLoading.init(),
                      theme: ThemeData(fontFamily: "montserrat"),
                      translations: LocalizationService(),
                      locale: LocalizationService().getCurrentLocale(),
                      fallbackLocale: const Locale('en', 'US'),
                      //home: const MainScreen(),
                      home: prefs.containsKey('uid')?const MainScreen():const LoginWeb(),
                    )
                  : FutureBuilder(
                      future: firebase,
                      builder: (context, snapshot) {
                        final provider = Provider.of<ProviderData>(context);
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (FirebaseAuth.instance.currentUser == null) {
                            //User is Logged out or doesn't Exist
                            if (shipperId != null) {
                              // print("Current transporter is not null and user is null");
                              return GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(fontFamily: "Montserrat"),
                                  translations: LocalizationService(),
                                  locale:
                                      LocalizationService().getCurrentLocale(),
                                  fallbackLocale: const Locale('en', 'US'),
                                  home: const SplashScreenToHomePage());
                            } else {
                              print("Current transporter is not null and user is null");
                              return GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(fontFamily: "Montserrat"),
                                  translations: LocalizationService(),
                                  locale:
                                      LocalizationService().getCurrentLocale(),
                                  fallbackLocale: const Locale('en', 'US'),
                                  home: const SplashScreenToLoginScreen());
                            }
                          } else {
                            if (shipperId != null) {
                              // print("Current transporter is not null and user is not null");
                              return GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(fontFamily: "Montserrat"),
                                  translations: LocalizationService(),
                                  locale:
                                      LocalizationService().getCurrentLocale(),
                                  fallbackLocale: const Locale('en', 'US'),
                                  home: const SplashScreenToHomePage());
                            } else {
                              print("Current transporter is null and user is not null");
                              return GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(fontFamily: "Montserrat"),
                                  translations: LocalizationService(),
                                  locale:
                                      LocalizationService().getCurrentLocale(),
                                  fallbackLocale: const Locale('en', 'US'),
                                  home: const SplashScreenToLoginScreen());
                            }
                          }
                        } else {
                          return ErrorScreen();
                        }
                      });
            });
          }),
    );
  }
}
