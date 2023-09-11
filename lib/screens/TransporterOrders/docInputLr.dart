import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/previewUploadedImage.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/TransporterOrders/docUploadBtn3.dart';
import 'package:image_picker/image_picker.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/spaces.dart';
import '/language/localization_service.dart';
//import '/screens/TransporterOrders/getDocApiCallVerify.dart';
//import '/screens/TransporterOrders/getDocumentApiCall.dart';
import '/screens/TransporterOrders/uploadedDocs.dart';
import '../../widgets/accountVerification/image_display.dart';
import 'docUploadBtn2.dart';
import 'dart:convert';
import 'dart:io';
import '/widgets/alertDialog/permissionDialog.dart';
import 'dart:io' as Io;
import 'package:permission_handler/permission_handler.dart';
//import 'getDocName.dart';
import '/functions/documentApi/getDocApiCallVerify.dart';
import '/functions/documentApi/getDocumentApiCall.dart';

class docInputLr extends StatefulWidget {
  var providerData;
  String? bookingId;

  docInputLr({
    this.providerData,
    this.bookingId,
  });

  @override
  State<docInputLr> createState() => _docInputLrState();
}

class _docInputLrState extends State<docInputLr> {
  String? bookid;
  bool showUploadedDocs = true;
  bool verified = false;
  bool showAddMoreDoc = true;
  var jsonresponse;
  var docLinks = [];
  String? currentLang;
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
  String addDocImageEng = "assets/images/uploadImage.png";
  String addDocImageHindi = "assets/images/uploadImage.png";
  String addDocImageEngMobile = "assets/images/AddDocumentImg.png";
  String addDocImageHindiMobile = "assets/images/AddDocumentImgHindi2.png";

  String addMoreDocImageEng = "assets/images/AddMoreDocImg.png";
  String addMoreDocImageHindi = "assets/images/AddMoreDocImgHindi.png";

  uploadedCheck() async {
    docLinks = [];
    docLinks = await getDocumentApiCall(bookid.toString(), "L");
    previewUploadedImage.updatePreviewImage(docLinks[0].toString());

    previewUploadedImage.updateIndex(0);
    // print(docLinks);
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
    print("verifiedCheck called");
    jsonresponse = await getDocApiCallVerify(bookid.toString(), "L");
    print("from verifiedCheck ${jsonresponse}");
    if (jsonresponse == true) {
      setState(() {
        verified = true;
      });
    } else {
      verified = false;
    }
  }

  @override
  void initState() {
    super.initState();
    print("current selected language :- ");
    print(LocalizationService().getCurrentLocale());
    currentLang = LocalizationService().getCurrentLocale().toString();
    print(currentLang);
    if (currentLang == "hi_IN") {
      // to change the image selecting image according to the language.
      setState(() {
        addDocImageEng = addDocImageHindi;
        addMoreDocImageEng = addMoreDocImageHindi;
        addDocImageEngMobile = addDocImageHindiMobile;
      });
    }

    bookid = widget.bookingId.toString();
    uploadedCheck();
  }

  String? docType;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 170,
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
                        "Upload Lorry Reciept".tr,
                        style: TextStyle(
                          color: white,
                          fontSize: size_7,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Responsive.isMobile(context)
                ? Container()
                : Stack(children: [
                    docLinks.isNotEmpty
                        ? SizedBox(
                            height: 320,
                            width: 730,
                            child: Obx(() {
                              return Image.network(
                                previewUploadedImage.previewImage.toString(),
                              );
                            }),
                          )
                        : Container(),
                  ]),
            Responsive.isMobile(context)
                ? Container()
                : SizedBox(
                    height: space_12,
                  ),
            Responsive.isMobile(context)
                ? Container(
                    height: 120,
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
                                      margin: EdgeInsets.only(right: 3, top: 4),
                                      height: 120,
                                      width: 180,
                                      child: verified
                                          ? Image(
                                              image: AssetImage(
                                                  "assets/images/verifiedDoc.png")) // to show verified document image if uploaded doucments get verified.
                                          : docUploadbtn2(
                                              assetImage: addDocImageEngMobile,
                                              onPressed: () async {
                                                widget.providerData.LrPhotoFile !=
                                                        null
                                                    ? Get.to(ImageDisplay(
                                                        providerData: widget
                                                            .providerData
                                                            .LrPhotoFile,
                                                        imageName: 'LrPhoto64',
                                                      ))
                                                    : showUploadedDocs
                                                        ? showPickerDialog(
                                                            widget.providerData
                                                                .updateLrPhoto,
                                                            widget.providerData
                                                                .updateLrPhotoStr,
                                                            context)
                                                        : null;
                                              },
                                              imageFile: widget
                                                  .providerData.LrPhotoFile,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                        docLinks.length < 4
                            ? showAddMoreDoc
                                ? (widget.providerData.LrPhotoFile == null)
                                    ? Flexible(
                                        child: Container(
                                          height: 110,
                                          width: 170,
                                          child: docUploadbtn2(
                                            assetImage: addMoreDocImageEng,
                                            onPressed: () async {
                                              if (widget.providerData
                                                      .LrPhotoFile ==
                                                  null) {
                                                showPickerDialog(
                                                    widget.providerData
                                                        .updateLrPhoto,
                                                    widget.providerData
                                                        .updateLrPhotoStr,
                                                    context);
                                                // : null;
                                              }
                                            },
                                            imageFile: null,
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container()
                            : Container()
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !showUploadedDocs
                          ? uploadedDocs(
                              docLinks: docLinks,
                              verified: verified,
                            )
                          : Stack(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 3, top: 4),
                                  height: 420,
                                  width: 878,
                                  child: verified
                                      ? const Image(
                                          image: AssetImage(
                                              "assets/images/verifiedDoc.png")) // to show verified document image if uploaded doucments get verified.
                                      : docUploadbtn2(
                                          assetImage: addDocImageEng,
                                          onPressed: () async {
                                            widget.providerData.LrPhotoFile !=
                                                    null
                                                ? Get.to(ImageDisplay(
                                                    providerData: widget
                                                        .providerData
                                                        .LrPhotoFile,
                                                    imageName: 'LrPhoto64',
                                                  ))
                                                : showUploadedDocs
                                                    ? showPickerDialog(
                                                        widget.providerData
                                                            .updateLrPhoto,
                                                        widget.providerData
                                                            .updateLrPhotoStr,
                                                        context)
                                                    : null;
                                          },
                                          imageFile:
                                              widget.providerData.LrPhotoFile,
                                        ),
                                ),
                              ],
                            ),
                      docLinks.length < 4 && docLinks.isNotEmpty
                          ? showAddMoreDoc
                              ? (widget.providerData.LrPhotoFile == null)
                                  ? Flexible(
                                      child: Container(
                                        height: 120,
                                        width: 180,
                                        child: docUploadbtn3(
                                          assetImage: addMoreDocImageEng,
                                          onPressed: () async {
                                            if (widget
                                                    .providerData.LrPhotoFile ==
                                                null) {
                                              showPickerDialog(
                                                  widget.providerData
                                                      .updateLrPhoto,
                                                  widget.providerData
                                                      .updateLrPhotoStr,
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
            Responsive.isMobile(context)
                ? Container()
                : SizedBox(
                    height: space_8,
                  ),
            docLinks.isNotEmpty
                ? Responsive.isMobile(context)
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "( Uploaded )".tr,
                          style: TextStyle(color: black),
                        ),
                      )
                    : SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              int i = previewUploadedImage.index.value;
                              if (previewUploadedImage.index <
                                  docLinks.length) {
                                previewUploadedImage.updatePreviewImage(
                                    docLinks[i++].toString());

                                previewUploadedImage.updateIndex(i++);
                              }
                            },
                            child: Text("Next"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    truckGreen // Set the background color here
                                )))
                : Container()
          ],
        ),
      ),
    );
  }

  showPickerDialog(var functionToUpdate, var strToUpdate, var context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return
              // child:
              Dialog(
            // shape:
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
                  // color: white,
                  child: ListTile(
                      textColor: black,
                      iconColor: black,
                      // selectedColor: darkBlueColor,
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
          // );
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
        // }
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;
      // if(kIsWeb) {
      //   picker = ImagePickerPlugin();
      //   pickedFile = await picker.pickImage(
      //       source: ImageSource.camera
      //   );
      //   bytes = await pickedFile.readAsBytes();
      // } else {
      //   picker = ImagePicker();
      //   pickedFile = await picker.pickImage(source: ImageSource.camera);
      //   bytes = await Io.File(pickedFile!.path).readAsBytes();
      // }
      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.camera);
      bytes = kIsWeb
          ? await pickedFile.readAsBytes()
          : await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
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
        showDialog(context: context, builder: (context) => PermissionDialog());
        // }
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;
      // if(kIsWeb) {
      //   picker = ImagePickerPlugin();
      //   picker = ImagePicker();
      //   pickedFile = await picker.pickImage(
      //       source: ImageSource.gallery
      //   );
      //   bytes = await pickedFile.readAsBytes();
      // } else {
      // picker = ImagePicker();
      // pickedFile = await picker.pickImage(source: ImageSource.gallery);
      // bytes = await Io.File(pickedFile!.path).readAsBytes();
      // }
      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      // print("pickedFile!.path ${pickedFile!.path}");
      bytes = kIsWeb
          ? await pickedFile.readAsBytes()
          : await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      functionToUpdate(File(pickedFile.path));
      strToUpdate(img64);
      setState(() {});
    }
  }
}
