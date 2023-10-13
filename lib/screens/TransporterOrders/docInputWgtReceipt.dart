import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/controller/previewUploadedImage.dart';
import 'package:shipper_app/responsive.dart';
import 'package:image_picker/image_picker.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';
import '/language/localization_service.dart';
import '/screens/TransporterOrders/uploadedDocs.dart';
import '../../widgets/accountVerification/image_display.dart';
import 'docUploadBtn2.dart';
import 'dart:convert';
import 'dart:io';
import '/widgets/alertDialog/permissionDialog.dart';
import 'dart:io' as Io;
import 'package:permission_handler/permission_handler.dart';
import '/functions/documentApi/getDocApiCallVerify.dart';
import '/functions/documentApi/getDocumentApiCall.dart';

// ignore: must_be_immutable
class docInputWgtReceipt extends StatefulWidget {
  var providerData;
  String? bookingId;

  docInputWgtReceipt({
    this.providerData,
    this.bookingId,
  });

  @override
  State<docInputWgtReceipt> createState() => _docInputWgtReceiptState();
}

class _docInputWgtReceiptState extends State<docInputWgtReceipt> {
  String? bookid;
  bool showUploadedDocs = true;
  bool verified = false;
  bool showAddMoreDoc = true;
  bool downloaded = false;
  bool downloading = false;
  var jsonresponse;
  var docLinks = [];
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
  String? currentLang;
  String addDocImageEng = "assets/images/uploadImage.png";
  String addDocImageHindi = "assets/images/uploadImage.png";

  String addDocImageEngMobile = "assets/images/AddDocumentImg.png";
  String addDocImageHindiMobile = "assets/images/AddDocumentImgHindi.png";

  String addMoreDocImageEng = "assets/images/AddMoreDocImg.png";
  String addMoreDocImageHindi = "assets/images/AddMoreDocImgHindi.png";

  uploadedCheck() async {
    docLinks = [];
    docLinks = await getDocumentApiCall(bookid.toString(), "W");
    if (docLinks.isNotEmpty) {
      previewUploadedImage.updatePreviewImage(docLinks[0].toString());

      previewUploadedImage.updateIndex(0);
    }
    if (docLinks.isNotEmpty) {
      setState(() {
        showUploadedDocs = false;
      });
      if (docLinks.length == 4) {
        setState(() {
          showAddMoreDoc = false;
        });
      }
      verifiedCheck();
    }
  }

  verifiedCheck() async {
    jsonresponse = await getDocApiCallVerify(bookid.toString(), "W");
    if (jsonresponse == true) {
      setState(() {
        verified = true;
      });
    } else {
      verified = false;
    }
  }

  void _saveNetworkImage(String path) async {
    await WebImageDownloader.downloadImageFromWeb(path, imageQuality: 0.5);
  }

  @override
  void initState() {
    super.initState();
    bookid = widget.bookingId;
    currentLang = LocalizationService().getCurrentLocale().toString();

    if (currentLang == "hi_IN") {
      setState(() {
        addDocImageEng = addDocImageHindi;
        addMoreDocImageEng = addMoreDocImageHindi;
        addDocImageEngMobile = addDocImageHindiMobile;
      });
    }

    uploadedCheck();
  }

  @override
  Widget build(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: SizedBox(
        height: Responsive.isMobile(context) ? screenHeight * 0.3 : 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Responsive.isMobile(context)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: darkBlueColor,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 6, bottom: 6),
                      child: Text(
                        "Upload Weight Receipt".tr,
                        style: TextStyle(
                          color: white,
                          fontSize: size_7,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Responsive.isMobile(context)
                ? SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !showUploadedDocs
                            ? Flexible(
                                flex: 2,
                                child: uploadedDocs(
                                  docLinks: docLinks,
                                  verified: verified,
                                ),
                              )
                            : Flexible(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 130,
                                      width: 170,
                                      child: verified
                                          ? const Image(
                                              image: AssetImage(
                                                  "assets/images/verifiedDoc.png"))
                                          : docUploadbtn2(
                                              assetImage: addDocImageEngMobile,
                                              onPressed: () async {
                                                widget.providerData
                                                            .WeightReceiptPhotoFile !=
                                                        null
                                                    ? Get.to(ImageDisplay(
                                                        providerData: widget
                                                            .providerData
                                                            .WeightReceiptPhotoFile,
                                                        imageName:
                                                            'WeightReceiptPhoto64',
                                                      ))
                                                    : showUploadedDocs
                                                        ? showPickerDialog(
                                                            widget.providerData
                                                                .updateWeightReceiptPhoto,
                                                            widget.providerData
                                                                .updateWeightReceiptPhotoStr,
                                                            context)
                                                        : null;
                                              },
                                              imageFile: widget.providerData
                                                  .WeightReceiptPhotoFile,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                        docLinks.length < 4
                            ? showAddMoreDoc
                                ? (widget.providerData.WeightReceiptPhotoFile ==
                                        null)
                                    ? Flexible(
                                        child: SizedBox(
                                          height: 116,
                                          width: 170,
                                          child: docUploadbtn2(
                                            assetImage: addMoreDocImageEng,
                                            onPressed: () async {
                                              if (widget.providerData
                                                      .WeightReceiptPhotoFile ==
                                                  null) {
                                                showPickerDialog(
                                                    widget.providerData
                                                        .updateWeightReceiptPhoto,
                                                    widget.providerData
                                                        .updateWeightReceiptPhotoStr,
                                                    context);
                                              }
                                            },
                                            imageFile: null,
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container()
                            : Container(),
                      ],
                    ),
                  )
                : Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 0.27), width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Image(
                                  image:
                                      AssetImage("assets/icons/document.png")),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Weight Receipt",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                  onPressed: docLinks.isNotEmpty
                                      ? () {
                                          imageDownload(context);
                                        }
                                      : null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: kLiveasyColor, width: 2.0)),
                                  ),
                                  child: const Text(
                                    "View Weight Receipt",
                                    style: TextStyle(color: kLiveasyColor),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              docLinks.isNotEmpty
                                  ? Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 30,
                                      width: 55,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[0].toString()}",
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 20,
                              ),
                              docLinks.isNotEmpty
                                  ? const Text("1+ Images ",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ))
                                  : const Text(" No Images",
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                              const SizedBox(
                                width: 70,
                              ),
                              GestureDetector(
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/images/uploadImage.png")),
                                  onTap: () {
                                    if (widget.providerData
                                            .WeightReceiptPhotoFile ==
                                        null) {
                                      showPickerDialog(
                                          widget.providerData
                                              .updateWeightReceiptPhoto,
                                          widget.providerData
                                              .updateWeightReceiptPhotoStr,
                                          context);
                                    } else {
                                      widget.providerData
                                                  .WeightReceiptPhotoFile !=
                                              null
                                          ? Get.to(ImageDisplay(
                                              providerData: widget.providerData
                                                  .WeightReceiptPhotoFile,
                                              imageName: 'WeightReceiptPhoto64',
                                            ))
                                          : showUploadedDocs
                                              ? showPickerDialog(
                                                  widget.providerData
                                                      .updateWeightReceiptPhoto,
                                                  widget.providerData
                                                      .updateWeightReceiptPhotoStr,
                                                  context)
                                              : null;
                                    }
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            docLinks.isNotEmpty
                ? Responsive.isMobile(context)
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "( Uploaded )".tr,
                          style: const TextStyle(color: black),
                        ),
                      )
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }

  showPickerDialog(var functionToUpdate, var strToUpdate, var context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            child: Wrap(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: white,
                  ),
                  width: 240,
                  child: ListTile(
                      textColor: black,
                      iconColor: black,
                      leading: const Icon(Icons.photo_library),
                      title: Text("Gallery".tr),
                      onTap: () async {
                        await getImageFromGallery2(
                            functionToUpdate, strToUpdate, context);
                        Navigator.of(context).pop();
                      }),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: white,
                  ),
                  width: 240,
                  child: ListTile(
                    textColor: black,
                    iconColor: black,
                    leading: const Icon(Icons.photo_camera),
                    title: Text("Camera".tr),
                    onTap: () async {
                      await getImageFromCamera2(
                          functionToUpdate, strToUpdate, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future getImageFromCamera2(
      var functionToUpdate, var strToUpdate, var context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        var pickedFile = await picker.pickImage(source: ImageSource.camera);
        final bytes = await Io.File(pickedFile!.path).readAsBytes();
        String img64 = base64Encode(bytes);
        functionToUpdate(File(pickedFile.path));
        strToUpdate(img64);
        setState(() {});
      } else {
        showDialog(context: context, builder: (context) => PermissionDialog());
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;

      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      bytes = await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      // print("Base64 is $img64");
      functionToUpdate(File(pickedFile.path));
      strToUpdate(img64);
      setState(() {});
    }
  }

  Future getImageFromGallery2(
      var functionToUpdate, var strToUpdate, var context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        var pickedFile = await picker.pickImage(source: ImageSource.gallery);
        final bytes = await Io.File(pickedFile!.path).readAsBytes();
        String img64 = base64Encode(bytes);
        functionToUpdate(File(pickedFile.path));
        strToUpdate(img64);
      } else {
        showDialog(
            context: context, builder: (context) => const PermissionDialog());
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;

      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      bytes = kIsWeb
          ? await pickedFile.readAsBytes()
          : await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      functionToUpdate(File(pickedFile.path));
      strToUpdate(img64);
      setState(() {});
    }
  }

  Future<void> imageDownload(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
    if (docLinks.isNotEmpty) {
      previewUploadedImage.updatePreviewImage(docLinks[0].toString());

      previewUploadedImage.updateIndex(0);
    }
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: space_25,
                ),
                Center(
                  child: Text(
                    " View Image",
                    style: TextStyle(
                      fontSize: size_10 - 1,
                      fontWeight: boldWeight,
                      color: darkBlueColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: darkBlueColor,
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                ),
              ],
            ),
            content: Column(
              children: [
                Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            int i = previewUploadedImage.index.value;
                            i = (i - 1) % docLinks.length;
                            previewUploadedImage
                                .updatePreviewImage(docLinks[i].toString());
                            previewUploadedImage.updateIndex(i);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor,
                          ),
                        ),
                        docLinks.isNotEmpty
                            ? docLinks.length > 0
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[0].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        docLinks.isNotEmpty
                            ? docLinks.length > 1
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[1].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        docLinks.isNotEmpty
                            ? docLinks.length > 2
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[2].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        docLinks.isNotEmpty
                            ? docLinks.length > 3
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[3].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        IconButton(
                          onPressed: () {
                            int i = previewUploadedImage.index.value;
                            i = (i + 1) % docLinks.length;
                            previewUploadedImage
                                .updatePreviewImage(docLinks[i].toString());
                            previewUploadedImage.updateIndex(i);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: darkBlueColor,
                          ),
                        )
                      ],
                    )),
                Flexible(
                  flex: 8,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(30),
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator(
                            color: darkBlueColor,
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(minHeight: 100),
                          color: whiteBackgroundColor,
                          child: Obx(() {
                            return Image.network(Uri.encodeFull(
                              "$proxyServer${previewUploadedImage.previewImage.toString()}",
                            ));
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, bottom: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            child: Container(
                              color: kLiveasyColor,
                              height: space_10,
                              child: Center(
                                child: downloading
                                    ? const CircularProgressIndicator(
                                        color: white,
                                      )
                                    : Text(
                                        "Download".tr,
                                        style: TextStyle(
                                          color: white,
                                          fontSize: size_8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            onTapUp: (value) {
                              setState(() {
                                downloading = true;
                              });
                            },
                            onTap: () async {
                              _saveNetworkImage(
                                  "$proxyServer${previewUploadedImage.previewImage.toString()}");
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            child: Container(
                              color: const Color(0xFFB6B6C1),
                              height: space_10,
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: const Color(0xFF000000),
                                    fontSize: size_8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Get.back();
                              setState(() {
                                downloading = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          );
        });
  }

  Future<void> uploadDoc(BuildContext context, var onPressed, var imageFile) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              child: imageFile == null
                  ? Center(
                      child: Image(
                          image: AssetImage("assets/images/uploadImage.png")),
                    )
                  : Stack(
                      children: [
                        Center(
                            child: imageFile != null
                                ? Image(image: Image.file(imageFile).image)
                                : Container()),
                        Center(
                          child: imageFile == null
                              ? Center(
                                  child: Container(),
                                )
                              : Center(
                                  child: Text(
                                    "Tap to Open",
                                    style: TextStyle(
                                        fontSize: size_6, color: liveasyGreen),
                                  ),
                                ),
                        ),
                      ],
                    ),
              onTap: onPressed,
            ),
          );
        });
  }
}
