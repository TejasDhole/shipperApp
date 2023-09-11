import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool progressBar = false;
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
    // String path =
    //     'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    // GallerySaver.saveImage(path, albumName: "Liveasy").then((bool? success) {
    //   setState(() {
    //     print('Image is saved');
    //     progressBar = false;
    //     downloaded = true;
    //     downloading = false;
    //   });
    // });
    var response = await Dio()
        .get(path, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "Liveasy");
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Row(
            children: [
              widget.verified
                  ? Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(right: 3, top: 4),
                        height: 120,
                        width: 180,
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
                              if (Responsive.isMobile(context)) {
                                Get.to(imageDisplayUsingApi(
                                  docLink: widget.docLinks[0].toString(),
                                ));
                              } else {
                                previewUploadedImage.updatePreviewImage(
                                    widget.docLinks[0].toString());

                                previewUploadedImage.updateIndex(0);
                                _imageDownload(context, 0);
                              }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 120,
                                    width: 180,
                                    child: Image.network(
                                      widget.docLinks[0].toString(),
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
                              if (Responsive.isMobile(context)) {
                                Get.to(imageDisplayUsingApi(
                                  docLink: widget.docLinks[1].toString(),
                                ));
                              } else {
                                previewUploadedImage.updatePreviewImage(
                                    widget.docLinks[1].toString());

                                previewUploadedImage.updateIndex(1);
                                _imageDownload(context, 1);
                              }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 120,
                                    width: 180,
                                    child: Image.network(
                                      widget.docLinks[1].toString(),
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
                              if (Responsive.isMobile(context)) {
                                Get.to(imageDisplayUsingApi(
                                  docLink: widget.docLinks[2].toString(),
                                ));
                              } else {
                                previewUploadedImage.updatePreviewImage(
                                    widget.docLinks[2].toString());

                                previewUploadedImage.updateIndex(2);
                                _imageDownload(context, 2);
                              }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 120,
                                    width: 180,
                                    child: Image.network(
                                      widget.docLinks[2].toString(),
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
                              if (Responsive.isMobile(context)) {
                                Get.to(imageDisplayUsingApi(
                                  docLink: widget.docLinks[3].toString(),
                                ));
                              } else {
                                previewUploadedImage.updatePreviewImage(
                                    widget.docLinks[3].toString());

                                previewUploadedImage.updateIndex(3);
                                _imageDownload(context, 3);
                              }
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 120,
                                    width: 180,
                                    child: Image.network(
                                      widget.docLinks[3].toString(),
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
        : Row(
            children: [
              widget.verified
                  ? Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(right: 3, top: 4),
                        height: 120,
                        width: 180,
                        child: const Image(
                          image: AssetImage("assets/images/verifiedDoc.png"),
                        ),
                      ),
                    )
                  : Container(),
              widget.docLinks.isNotEmpty
                  ? i1
                      ? GestureDetector(
                          onTap: () {
                            if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[0].toString(),
                              ));
                            } else {
                              previewUploadedImage.updatePreviewImage(
                                  widget.docLinks[0].toString());

                              previewUploadedImage.updateIndex(0);
                              _imageDownload(context, 0);
                            }
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  color: whiteBackgroundColor,
                                  margin:
                                      const EdgeInsets.only(right: 3, top: 4),
                                  height: 120,
                                  width: 180,
                                  child: Image.network(
                                    widget.docLinks[0].toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 1
                  ? i2
                      ? GestureDetector(
                          onTap: () {
                            if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[1].toString(),
                              ));
                            } else {
                              previewUploadedImage.updatePreviewImage(
                                  widget.docLinks[1].toString());

                              previewUploadedImage.updateIndex(1);
                              _imageDownload(context, 1);
                            }
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  color: whiteBackgroundColor,
                                  margin:
                                      const EdgeInsets.only(right: 3, top: 4),
                                  height: 120,
                                  width: 180,
                                  child: Image.network(
                                    widget.docLinks[1].toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 2
                  ? i3
                      ? GestureDetector(
                          onTap: () {
                            if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[2].toString(),
                              ));
                            } else {
                              previewUploadedImage.updatePreviewImage(
                                  widget.docLinks[2].toString());

                              previewUploadedImage.updateIndex(2);
                              _imageDownload(context, 2);
                            }
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  color: whiteBackgroundColor,
                                  margin:
                                      const EdgeInsets.only(right: 3, top: 4),
                                  height: 120,
                                  width: 180,
                                  child: Image.network(
                                    widget.docLinks[2].toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container(),
              widget.docLinks.length > 3
                  ? i4
                      ? GestureDetector(
                          onTap: () {
                            if (Responsive.isMobile(context)) {
                              Get.to(imageDisplayUsingApi(
                                docLink: widget.docLinks[3].toString(),
                              ));
                            } else {
                              previewUploadedImage.updatePreviewImage(
                                  widget.docLinks[3].toString());

                              previewUploadedImage.updateIndex(3);
                              _imageDownload(context, 3);
                            }
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  color: whiteBackgroundColor,
                                  margin:
                                      const EdgeInsets.only(right: 3, top: 4),
                                  height: 120,
                                  width: 180,
                                  child: Image.network(
                                    widget.docLinks[3].toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container(),
            ],
          );
  }

  Future<void> _imageDownload(BuildContext context, int i) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: space_10,
                ),
                Text(
                  " View Image",
                  style: TextStyle(
                    fontSize: size_10 - 1,
                    fontWeight: boldWeight,
                    color: darkBlueColor,
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
              ],
            ),
            content: Container(
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
                      child: Image.network(
                        widget.docLinks[i].toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 150, right: 150, bottom: 10, top: 10),
                child: ClipRRect(
                  child: InkWell(
                    child: Container(
                      color: const Color(0xFF09B778),
                      height: space_10,
                      child: Center(
                        child: progressBar
                            ? const CircularProgressIndicator(
                                color: white,
                              )
                            : Text(
                                "Download".tr,
                                style: TextStyle(
                                    color: white,
                                    fontSize: size_8,
                                    fontWeight: FontWeight.bold),
                              ),
                        // ),
                      ),
                    ),
                    onTapUp: (value) {
                      setState(() {
                        progressBar = true;
                        downloading = true;
                      });
                    },
                    onTap: () async {
                      _saveNetworkImage(widget.docLinks[i].toString());
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}
