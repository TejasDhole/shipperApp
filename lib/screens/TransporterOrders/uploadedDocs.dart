import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/responsive.dart';
import '../../controller/previewUploadedImage.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/screens/TransporterOrders/imageDisplayUsingApi.dart';

class uploadedDocs extends StatefulWidget {
  bool verified;

  List docLinks = [];

  uploadedDocs({required this.docLinks, required this.verified});
  @override
  State<uploadedDocs> createState() => _uploadedDocsState();
}

class _uploadedDocsState extends State<uploadedDocs> {
  bool i1 = false;
  bool i2 = false;
  bool i3 = false;
  bool i4 = false;
  bool downloaded = false;
  bool downloading = false;
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
  @override
  void initState() {
    super.initState();
    if (widget.docLinks.length > 0) {
      var image1 = Image.network(
        widget.docLinks[0].toString(),
      );
      if (image1 != null) {
        setState(() {
          i1 = true;
        });
      }
    }
    if (widget.docLinks.length > 1) {
      var image2 = Image.network(
        widget.docLinks[1].toString(),
      );
      if (image2 != null) {
        setState(() {
          i2 = true;
        });
      }
    }
    if (widget.docLinks.length > 2) {
      var image3 = Image.network(
        widget.docLinks[2].toString(),
      );
      if (image3 != null) {
        setState(() {
          i3 = true;
        });
      }
    }
    if (widget.docLinks.length > 3) {
      var image4 = Image.network(
        widget.docLinks[3].toString(),
      );
      if (image4 != null) {
        setState(() {
          i4 = true;
        });
      }
    }
  }

  void _saveNetworkImage(String path) async {
    await WebImageDownloader.downloadImageFromWeb(path, imageQuality: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
    return Responsive.isMobile(context)
        ? Row(
            children: [
              widget.verified
                  ? Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(right: 3, top: 4),
                        height: 110,
                        width: 170,
                        child: const Image(
                          image: AssetImage("assets/images/verifiedDoc.png"),
                        ),
                      ),
                    )
                  : Container(),
              widget.docLinks.isNotEmpty
                  ? i1
                      ? Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[0].toString(),
                              ));
                              // } else {
                              //   previewUploadedImage.updatePreviewImage(
                              //       widget.docLinks[0].toString());

                              //   previewUploadedImage.updateIndex(0);
                              //   imageDownload(context);
                              // }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 130,
                                    width: 180,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${widget.docLinks[0].toString()}",
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Tap to Open".tr,
                                    style: TextStyle(
                                        fontSize: size_6, color: liveasyGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 1
                  ? i2
                      ? Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[1].toString(),
                              ));
                              // } else {
                              //   previewUploadedImage.updatePreviewImage(
                              //       widget.docLinks[1].toString());

                              //   previewUploadedImage.updateIndex(1);
                              //   imageDownload(context);
                              // }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 130,
                                    width: 180,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${widget.docLinks[1].toString()}",
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Tap to Open".tr,
                                    style: TextStyle(
                                        fontSize: size_6, color: liveasyGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 2
                  ? i3
                      ? Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[2].toString(),
                              ));
                              // } else {
                              //   previewUploadedImage.updatePreviewImage(
                              //       widget.docLinks[2].toString());

                              //   previewUploadedImage.updateIndex(2);
                              //   imageDownload(context);
                              // }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 130,
                                    width: 180,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${widget.docLinks[2].toString()}",
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Tap to Open".tr,
                                    style: TextStyle(
                                        fontSize: size_6, color: liveasyGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 3
                  ? i4
                      ? Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[3].toString(),
                              ));
                              // } else {
                              //   previewUploadedImage.updatePreviewImage(
                              //       widget.docLinks[3].toString());

                              //   previewUploadedImage.updateIndex(3);
                              //   imageDownload(context);
                              // }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 130,
                                    width: 180,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${widget.docLinks[3].toString()}",
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Tap to Open".tr,
                                    style: TextStyle(
                                        fontSize: size_6, color: liveasyGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                  : Container(),
            ],
          )
        : Container(
            child: GestureDetector(
            onTap: () => imageDownload(context),
          ));
    // : Row(
    //     children: [
    //       widget.verified
    //           ? Flexible(
    //               child: Container(
    //                 margin: const EdgeInsets.only(right: 3, top: 4),
    //                 height: 120,
    //                 width: 180,
    //                 child: const Image(
    //                   image: AssetImage("assets/images/verifiedDoc.png"),
    //                 ),
    //               ),
    //             )
    //           : Container(),
    //       widget.docLinks.isNotEmpty
    //           ? i1
    //               ? GestureDetector(
    //                   onTap: () {
    //                     // if (Responsive.isMobile(context)) {
    //                     //   Get.to(imageDisplayUsingApi(
    //                     //     docLink: widget.docLinks[0].toString(),
    //                     //   ));
    //                     // } else {
    //                     previewUploadedImage.updatePreviewImage(
    //                         widget.docLinks[0].toString());

    //                     previewUploadedImage.updateIndex(0);
    //                     imageDownload(context);
    //                     // }
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Center(
    //                         child: Container(
    //                           color: whiteBackgroundColor,
    //                           margin:
    //                               const EdgeInsets.only(right: 3, top: 4),
    //                           height: 120,
    //                           width: 180,
    //                           child: Image(
    //                             image: NetworkImage(
    //                               "$proxyServer${widget.docLinks[0].toString()}",
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : Container()
    //           : Container(),
    //       widget.docLinks.length > 1
    //           ? i2
    //               ? GestureDetector(
    //                   onTap: () {
    //                     // if (Responsive.isMobile(context)) {
    //                     //   Get.to(imageDisplayUsingApi(
    //                     //     docLink: widget.docLinks[1].toString(),
    //                     //   ));
    //                     // } else {
    //                     previewUploadedImage.updatePreviewImage(
    //                         widget.docLinks[1].toString());

    //                     previewUploadedImage.updateIndex(1);
    //                     imageDownload(context);
    //                     //  }
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Center(
    //                         child: Container(
    //                           color: whiteBackgroundColor,
    //                           margin:
    //                               const EdgeInsets.only(right: 3, top: 4),
    //                           height: 120,
    //                           width: 180,
    //                           child: Image(
    //                             image: NetworkImage(
    //                               "$proxyServer${widget.docLinks[1].toString()}",
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : Container()
    //           : Container(),
    //       widget.docLinks.length > 2
    //           ? i3
    //               ? GestureDetector(
    //                   onTap: () {
    //                     // if (Responsive.isMobile(context)) {
    //                     //   Get.to(imageDisplayUsingApi(
    //                     //     docLink: widget.docLinks[2].toString(),
    //                     //   ));
    //                     // } else {
    //                     previewUploadedImage.updatePreviewImage(
    //                         widget.docLinks[2].toString());

    //                     previewUploadedImage.updateIndex(2);
    //                     imageDownload(context);
    //                     // }
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Center(
    //                         child: Container(
    //                           color: whiteBackgroundColor,
    //                           margin:
    //                               const EdgeInsets.only(right: 3, top: 4),
    //                           height: 120,
    //                           width: 180,
    //                           child: Image(
    //                             image: NetworkImage(
    //                               "$proxyServer${widget.docLinks[2].toString()}",
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : Container()
    //           : Container(),
    //       widget.docLinks.length > 3
    //           ? i4
    //               ? GestureDetector(
    //                   onTap: () {
    //                     // if (Responsive.isMobile(context)) {
    //                     //   Get.to(imageDisplayUsingApi(
    //                     //     docLink: widget.docLinks[3].toString(),
    //                     //   ));
    //                     // } else {
    //                     previewUploadedImage.updatePreviewImage(
    //                         widget.docLinks[3].toString());

    //                     previewUploadedImage.updateIndex(3);
    //                     imageDownload(context);
    //                     // }
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Center(
    //                         child: Container(
    //                           color: whiteBackgroundColor,
    //                           margin:
    //                               const EdgeInsets.only(right: 3, top: 4),
    //                           height: 120,
    //                           width: 180,
    //                           child: Image(
    //                             image: NetworkImage(
    //                               "$proxyServer${widget.docLinks[3].toString()}",
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : Container()
    //           : Container(),
    //     ],
    //   );
  }

  Future<void> imageDownload(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
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
                            i = (i - 1) % widget.docLinks.length;
                            previewUploadedImage.updatePreviewImage(
                                widget.docLinks[i].toString());
                            previewUploadedImage.updateIndex(i);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor,
                          ),
                        ),
                        widget.docLinks.isNotEmpty
                            ? i1
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${widget.docLinks[0].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        widget.docLinks.isNotEmpty
                            ? i2
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${widget.docLinks[1].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        widget.docLinks.isNotEmpty
                            ? i3
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${widget.docLinks[2].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        widget.docLinks.isNotEmpty
                            ? i4
                                ? Center(
                                    child: Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 100,
                                      width: 150,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${widget.docLinks[3].toString()}",
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                        IconButton(
                          onPressed: () {
                            int i = previewUploadedImage.index.value;
                            i = (i + 1) % widget.docLinks.length;
                            previewUploadedImage.updatePreviewImage(
                                widget.docLinks[i].toString());
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
}
