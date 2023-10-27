import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/borderWidth.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/functions/selectedLocationPostLoad.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/functions/placeAutoFillUtils/autoFillGoogle.dart';
import '/functions/placeAutoFillUtils/autoFillMMI.dart';
import '/providerClass/providerData.dart';
import '/widgets/autoFillDataDisplayCard.dart';
import '/widgets/buttons/backButtonWidget.dart';
import '/widgets/textFieldWidget.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import '../functions/placeAutoFillUtils/autoFillRapidSpott.dart';
import '/widgets/cancelIconWidget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

class CityNameInputScreen extends StatefulWidget {
  final String page;
  final String valueType;

  CityNameInputScreen(this.page, this.valueType);

  @override
  _CityNameInputScreenState createState() => _CityNameInputScreenState();
}

class _CityNameInputScreenState extends State<CityNameInputScreen> {
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController txtCityController = TextEditingController();
  TextEditingController txtStateController = TextEditingController();
  late final FocusNode focus;
  late final FocusNode focusTextField;
  int selectedItemIndex = -1;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late Position currentPosition;
  var logger;

  @override
  void initState() {
    super.initState();
    focus = FocusNode();
    focusTextField = FocusNode();
    focusTextField.requestFocus();
    logger = Logger();
    async_method();
    _initSpeech();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focus.dispose();
    focusTextField.dispose();
    super.dispose();
  }

  void async_method() async {
    await getCurrentPosition();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    //final hasPermission = await _handleLocationPermission();
    //if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      print(position);
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      // logger.i("got error in while getting current position");
      // debugPrint(e);
      print("error : $e");
    });
  }

  var locationCard;
  TextEditingController controller = TextEditingController();

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      controller = TextEditingController(text: _lastWords);
      if (widget.page == "postLoad") {
        locationCard = fillCityGoogle(controller.text,
            currentPosition); //google place api is used in postLoad
      } else {
        locationCard = fillCity(controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    focus.requestFocus();
    double keyboardLength = MediaQuery.of(context).viewInsets.bottom;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(0),
        child: Container(
          height: Get.height * 0.70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadDetailsHeader(
                  title: 'Location Details',
                  subTitle: 'Tell us your location details',
                  visibleWidget: HomeScreenWeb(
                    index: 0,
                    selectedIndex: 0,
                  )),
              Container(
                height: 10,
                color: lineDividerColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: (Responsive.isMobile(context)) ? 10 : 40),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: kLiveasyColor, width: borderWidth_20),
                ),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  focusNode: focusTextField,
                  controller: controller,
                  enableInteractiveSelection: false,
                  onChanged: (String value) {
                    setState(() {
                      if (widget.page == "postLoad") {
                        locationCard = fillCityGoogle(value, currentPosition);
                        //google place api is used in postLoad
                      } else {
                        locationCard = fillCity(
                            value); //return auto suggested places using rapid api
                      } //return auto suggested places using MapMyIndia api
                      selectedItemIndex = -1;
                    });
                  },
                  onFieldSubmitted: (value) {
                    if (!Responsive.isMobile(context)) {
                      setState(() {});
                    }
                  },
                  onTapOutside: (value) {
                    if (!Responsive.isMobile(context)) {
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'enterCityName'.tr,
                    prefixIcon: GestureDetector(
                        onTap: _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                        child: Icon(_speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.clear();
                        },
                        icon: CancelIconWidget()),
                  ),
                ),
              ),
              locationCard != null
                  ? (Responsive.isMobile(
                          context)) // for mobile keyboard operations is not required.
                      ? FutureBuilder(
                          future: locationCard,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if ((controller.text == null ||
                                      controller.text.isEmpty) &&
                                  (snapshot.data == null ||
                                      snapshot.data.isEmpty)) {
                                return Container();
                              } else if ((controller.text != null ||
                                      controller.text.isNotEmpty) &&
                                  (snapshot.data == null ||
                                      snapshot.data.isEmpty)) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: AddMissingLocationButton(context));
                              }
                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                height: keyboardLength != 0
                                    ? screenHeight - keyboardLength - 50
                                    : screenHeight - 300,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    border: Border.all(color: white, width: 0)),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  reverse: false,
                                  // padding: EdgeInsets.symmetric(
                                  //   horizontal: space_2,
                                  // ),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) =>
                                      AutoFillDataDisplayCard(
                                          snapshot.data[index].placeName,
                                          snapshot
                                              .data[index].addresscomponent1,
                                          snapshot.data[index].placeCityName,
                                          snapshot.data[index].placeStateName,
                                          index,
                                          selectedItemIndex, () {
                                    selectedLocationPostLoad(
                                        context,
                                        snapshot.data[index].placeName,
                                        snapshot.data[index].addresscomponent1,
                                        snapshot.data[index].placeCityName,
                                        snapshot.data[index].placeStateName,
                                        widget.valueType);
                                    Get.back();
                                  }),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      thickness: 1,
                                      height: 1,
                                      color: black,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })
                      : Expanded(
                          child: Center(
                              child: FutureBuilder(
                                  future: locationCard,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if ((controller.text == null ||
                                              controller.text.isEmpty) &&
                                          (snapshot.data == null ||
                                              snapshot.data.isEmpty)) {
                                        return Container();
                                      } else if ((controller.text != null ||
                                              controller.text.isNotEmpty) &&
                                          (snapshot.data == null ||
                                              snapshot.data.isEmpty)) {
                                        return AddMissingLocationButton(
                                            context);
                                      }
                                      return Container(
                                        height: Get.height * 0.40,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: black, width: 2)),
                                        child: RawKeyboardListener(
                                          focusNode: focus,
                                          onKey: (value) {
                                            if (value.logicalKey ==
                                                    LogicalKeyboardKey
                                                        .arrowUp &&
                                                value is RawKeyUpEvent) {
                                              // focus previous item
                                              if (selectedItemIndex > 0) {
                                                setState(() {
                                                  selectedItemIndex--;
                                                });
                                              }
                                            } else if (value.logicalKey ==
                                                    LogicalKeyboardKey
                                                        .arrowDown &&
                                                value is RawKeyDownEvent) {
                                              //focus next item
                                              if (selectedItemIndex <
                                                  snapshot.data.length - 1) {
                                                setState(() {
                                                  selectedItemIndex++;
                                                });
                                              }
                                            } else if (value.logicalKey ==
                                                    LogicalKeyboardKey.enter &&
                                                value is RawKeyUpEvent) {
                                              //select an item using enter key and then update location in provider data and back to previous screen
                                              if (selectedItemIndex != -1 &&
                                                  selectedItemIndex <
                                                      snapshot.data.length) {
                                                selectedLocationPostLoad(
                                                    context,
                                                    snapshot
                                                        .data[selectedItemIndex]
                                                        .placeName,
                                                    snapshot
                                                        .data[selectedItemIndex]
                                                        .addresscomponent1,
                                                    snapshot
                                                        .data[selectedItemIndex]
                                                        .placeCityName,
                                                    snapshot
                                                        .data[selectedItemIndex]
                                                        .placeStateName,
                                                    widget.valueType);
                                                Get.back();
                                              }
                                            } else if (value.logicalKey ==
                                                    LogicalKeyboardKey
                                                        .backspace &&
                                                value is RawKeyUpEvent) {
                                              if (controller.text.isNotEmpty) {
                                                String txt =
                                                    controller.text.toString();
                                                txt = txt.substring(
                                                    0, txt.length - 1);
                                                controller.text = txt;
                                                setState(() {
                                                  locationCard = fillCityGoogle(
                                                      controller.text,
                                                      currentPosition);
                                                });
                                              }
                                            } else if (value.logicalKey.keyId >=
                                                    32 &&
                                                value.logicalKey.keyId <= 126 &&
                                                value is RawKeyUpEvent) {
                                              String txt =
                                                  controller.text.toString();
                                              txt += value.data.keyLabel
                                                  .toString();
                                              controller.text = txt;
                                              setState(() {
                                                locationCard = fillCityGoogle(
                                                    controller.text,
                                                    currentPosition);
                                              });
                                            }
                                          },
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            reverse: false,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) =>
                                                AutoFillDataDisplayCard(
                                                    snapshot
                                                        .data[index].placeName,
                                                    snapshot.data[index]
                                                        .addresscomponent1,
                                                    snapshot.data[index]
                                                        .placeCityName,
                                                    snapshot.data[index]
                                                        .placeStateName,
                                                    index,
                                                    selectedItemIndex, () {
                                              selectedLocationPostLoad(
                                                  context,
                                                  snapshot
                                                      .data[index].placeName,
                                                  snapshot.data[index]
                                                      .addresscomponent1,
                                                  snapshot.data[index]
                                                      .placeCityName,
                                                  snapshot.data[index]
                                                      .placeStateName,
                                                  widget.valueType);
                                              Get.back();
                                            }),
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(
                                                thickness: 1,
                                                height: 1,
                                                color: black,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget AddMissingLocationButton(context) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text(
            'Add Missing Address',
            style: TextStyle(
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_8,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(truckGreen),
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 30, vertical: 30)),
            mouseCursor: MaterialStatePropertyAll(SystemMouseCursors.click),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 10,
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Enter Address',
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontSize: size_10,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: txtAddressController,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontFamily: 'Montserrat',
                              fontSize: size_8),
                          textAlign: TextAlign.center,
                          cursorColor: kLiveasyColor,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: borderLightColor, width: 1.5)),
                              hintText: 'Enter Area Name/ Road No/ Address',
                              hintStyle: TextStyle(
                                  color: borderLightColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_8),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: truckGreen, width: 1.5))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Enter City',
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontSize: size_10,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: txtCityController,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontFamily: 'Montserrat',
                              fontSize: size_8),
                          textAlign: TextAlign.center,
                          cursorColor: kLiveasyColor,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: borderLightColor, width: 1.5)),
                              hintText: 'Enter City',
                              hintStyle: TextStyle(
                                  color: borderLightColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_8),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: truckGreen, width: 1.5))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Enter State',
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontSize: size_10,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: txtStateController,
                          style: TextStyle(
                              color: kLiveasyColor,
                              fontFamily: 'Montserrat',
                              fontSize: size_8),
                          textAlign: TextAlign.center,
                          cursorColor: kLiveasyColor,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: borderLightColor, width: 1.5)),
                              hintText: 'Enter State',
                              hintStyle: TextStyle(
                                  color: borderLightColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: size_8),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                      color: truckGreen, width: 1.5))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                String address = txtAddressController.text;
                                String city = txtCityController.text;
                                String state = txtStateController.text;

                                if (address.isNotEmpty &&
                                    address != null &&
                                    city.isNotEmpty &&
                                    city != null &&
                                    state.isNotEmpty &&
                                    state != null) {
                                  Navigator.of(context).pop();
                                  selectedLocationPostLoad(context, address,
                                      null, city, state, widget.valueType);
                                  Get.back();
                                }
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  mouseCursor: MaterialStatePropertyAll(
                                      SystemMouseCursors.click),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: truckGreen,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 8)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(truckGreen)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(red),
                                  mouseCursor: MaterialStatePropertyAll(
                                      SystemMouseCursors.click),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: red,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 8)),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
