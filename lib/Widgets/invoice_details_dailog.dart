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
import 'package:universal_html/html.dart'  as html;
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

  // This function  creates PDF and download it
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

    // Trigger the file download
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'invoice.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // This function  converts network image to byte
  Future<Uint8List> networkImageToByte(String imageUrl) async {
    final response = await http.get(Uri.parse('$proxy$imageUrl'));
    final bytes = response.bodyBytes;
    return bytes;
  }

  // This function fetch list of invoice image link  from document api
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
      title: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          const Text(
            'Invoice.png',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      content: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: white,
              width: docLinks.isNotEmpty
                  ? MediaQuery.of(context).size.width * 0.85
                  : MediaQuery.of(context).size.width * 0.2,
              height: docLinks.isEmpty
                  ? MediaQuery.of(context).size.height * 0.15
                  : MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: docLinks.isNotEmpty
                    ? Column(
                        children: docLinks.map<Widget>((link) {
                          return Column(
                            children: [
                              Image.network('$proxy$link',
                                  errorBuilder: (context, error, stackTrace) {
                                // when there is error in fetching image
                                return const Text('Error in fetching Invoice',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(158, 158, 158, 1)));
                              }),
                              const Divider(
                                height: 10,
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    // when there is no invoice uploaded
                    : SizedBox(
                        height: 100,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Invoice not found",
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
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: darkBlueColor),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
                    width: 200,
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
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.download, color: white),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Download".tr,
                                          style: TextStyle(
                                            color: white,
                                            fontSize: size_8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        onTap: () async {
                          if (docLinks.isNotEmpty) {
                            setState(() {
                              downloading = true;
                            });
                            await createPdfAndDownload(docLinks.cast<String>());
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
      ],
      surfaceTintColor: Colors.transparent,
    );
  }
}
