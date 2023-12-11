import 'package:flutter/material.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/functions/documentApi/getDocApiCallVerify.dart';
import 'package:shipper_app/functions/documentApi/getInvoiceDocApiCall.dart';

class InvoiceDetails extends StatefulWidget {
  String? invoiceId;
  InvoiceDetails({this.invoiceId});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  var docLinks = [];

  uploadedCheck() async {
    try {
      docLinks = await getInvoiceDocApiCall(widget.invoiceId.toString(), "I");
      print(docLinks);
    } catch (e) {
      print("Error fetching docLinks: $e");
    }

    setState(() {
      docLinks = docLinks;
    });
  }

  @override
  void initState() {
    super.initState();
    uploadedCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Invoice.png',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF152968),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Image.network(
              docLinks != null && docLinks.isNotEmpty && docLinks[0] != null
                  ? docLinks[0].toString()
                  : "",
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Text('Could not load image');
              },
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
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
                          color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //getDocApiCallVerify(bookid.toString(),
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: darkBlueColor,
                      minimumSize: const Size(250, 50),
                      alignment: Alignment.center,
                    ),
                    child: const Text(
                      'Download',
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
