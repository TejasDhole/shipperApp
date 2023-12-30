import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/functions/documentApi/getInvoiceDocApiCall.dart';
import 'package:shipper_app/functions/uploadingDoc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class InvoiceDetails extends StatefulWidget {
  final String? invoiceId;
  InvoiceDetails({this.invoiceId});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  var docLinks = [];
  bool loading = true;
  final String proxy = dotenv.get('placeAutoCompleteProxy');

  @override
  void initState() {
    super.initState();
    uploadedCheck();
  }

  Future<void> createPdfAndDownload(List<String> imageUrls) async {
    final pdf = pw.Document();

    for (var imageUrl in imageUrls) {
      final image = await networkImageToByte(imageUrl);
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(pw.MemoryImage(image)),
        );
      }));
    }
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> networkImageToByte(String imageUrl) async {
    final response = await http.get(Uri.parse('$proxy$imageUrl'));
    final bytes = response.bodyBytes;
    return bytes;
  }

  uploadedCheck() async {
    try {
      docLinks = await getInvoiceDocApiCall(widget.invoiceId.toString(), "I");
    } catch (e) {
      debugPrint("Error fetching docLinks: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'Invoice.png',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        content: loading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: docLinks.isNotEmpty
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.3,
                height: docLinks.isEmpty
                    ? MediaQuery.of(context).size.height * 0.15
                    : docLinks.length == 1
                        ? MediaQuery.of(context).size.height * 0.3
                        : MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: docLinks.isNotEmpty
                      ? Column(
                          children: docLinks.map<Widget>((link) {
                            return Column(
                              children: [
                                Image.network(
                                  '$proxy$link',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Image not found',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  158, 158, 158, 1))),
                                ),
                                const Divider(
                                  height: 10,
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      : SizedBox(
                          height: 100,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Image not found",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: normalWeight),
                              )),
                        ),
                ),
              ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              docLinks.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(250, 50),
                          alignment: Alignment.center,
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              docLinks.isEmpty
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            child: Container(
                              color: kLiveasyColor,
                              height: space_10,
                              child: Center(
                                child: Text(
                                  "close".tr,
                                  style: TextStyle(
                                    color: white,
                                    fontSize: size_8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(),
              docLinks.isEmpty
                  ? Container()
                  : SizedBox(
                      width: 100,
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
                            downloading = true;
                          },
                          onTap: () async {
                            if (docLinks.isNotEmpty) {
                              setState(() {
                                downloading = true;
                              });
                              await createPdfAndDownload(
                                  docLinks.cast<String>());
                              setState(() {
                                downloading = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
            ],
          )
        ]);
  }
}
