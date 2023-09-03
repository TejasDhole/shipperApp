import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/borderWidth.dart';
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
  late final FocusNode focus;
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
    logger = Logger();
    async_method();
    // getMMIToken();
    // logger.i("back from mmitoken");
    _initSpeech();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focus.dispose();
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

  selectSuggestedLocation(
      context, placeName, addressName, cityName, stateName) {
    //Update selected location on provider data and back to previous screen based on widget.valueType
    ProviderData providerData =
        Provider.of<ProviderData>(context, listen: false);
    if (widget.valueType == "Loading Point") {
      providerData.updateLoadingPointFindLoad(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    } else if (widget.valueType == "Unloading Point") {
      providerData.updateUnloadingPointFindLoad(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    } else if (widget.valueType == "Loading point" ||
        widget.valueType == "Loading point 1") {
      providerData.updateLoadingPointPostLoad(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    } else if (widget.valueType == "Loading point 2") {
      providerData.updateLoadingPointPostLoad2(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    } else if (widget.valueType == "Unloading point" ||
        widget.valueType == "Unloading point 1") {
      providerData.updateUnloadingPointPostLoad(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    } else if (widget.valueType == "Unloading point 2") {
      providerData.updateUnloadingPointPostLoad2(
          place: addressName == null ? placeName : '$placeName, $addressName',
          city: cityName,
          state: stateName);
      Get.back();
    }
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
                  subTitle: 'Tell us your location details'),
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
                  autofocus: true,
                  controller: controller,
                  // onChanged: widget.onChanged,
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
                  ? (Responsive.isMobile(context)) // for mobile keyboard operations is not required.
                      ? FutureBuilder(
                          future: locationCard,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null ||
                                  snapshot.data.isEmpty) {
                                return Container();
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
                                    selectSuggestedLocation(
                                        context,
                                        snapshot.data[index].placeName,
                                        snapshot.data[index].addresscomponent1,
                                        snapshot.data[index].placeCityName,
                                        snapshot.data[index].placeStateName);
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
                                      if (snapshot.data == null ||
                                          snapshot.data.isEmpty) {
                                        return Container();
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
                                                selectSuggestedLocation(
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
                                                        .placeStateName);
                                              }
                                            }
                                          },
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
                                              selectSuggestedLocation(
                                                  context,
                                                  snapshot
                                                      .data[index].placeName,
                                                  snapshot.data[index]
                                                      .addresscomponent1,
                                                  snapshot.data[index]
                                                      .placeCityName,
                                                  snapshot.data[index]
                                                      .placeStateName);
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
}
