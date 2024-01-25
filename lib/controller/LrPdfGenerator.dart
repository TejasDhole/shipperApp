import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shipper_app/controller/shipperIdController.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

//Gets eway bill userId using company Id
getEwayBillUser() async {
    try {

      ShipperIdController shipperIdController = Get.put(ShipperIdController());

      final String ewayURL = dotenv.get('ewayBillUser');

      final response = await http.get(Uri.parse(
          "$ewayURL/ewayBillUser/${shipperIdController.companyId.value}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['username'];
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
}

//get Lr details using ewbNo and userId
getLrDetails(String lrNo) async{
  final String ewayBaseURL = dotenv.get("ewayBill");

  final String userId = await getEwayBillUser();

  if(userId==null){
    return null;
  }

  Uri url = Uri.parse("$ewayBaseURL?ewbNo=$lrNo&userId=$userId");


  http.Response response = await http.get(url);

  if(response.statusCode == 200){
    return json.decode(response.body);
  }
  else{
    return null;
  }
}

//generate pdf using eway bill details, null or missing data will be filled by empty string ''
createPdf(String transporterName, String transporterAddress, String lrNo, String fromAddr1, String toAddr1, String vehicleNo, String docDate, String fromTrdName, String fromGstin, String toTrdName, String toGstin, String quantity, String qtyUnit, String productName, String hsnCode) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(10),
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: const PdfColorCmyk.fromRgb(0, 0, 0.4164),
              child: pw.Row(
                children: [
                  pw.Text(transporterName,
                      maxLines: 2,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 25,
                        fontWeight: pw.FontWeight.bold,
                      ))
                ],
              )),
          pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: const PdfColorCmyk.fromRgb(0, 0, 0.4164),
              child: pw.Row(children: [
                pw.Expanded(
                    flex: 65,
                    child: pw.Text(transporterAddress,
                        maxLines: 2,
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 14))),
                pw.Expanded(
                    flex: 35,
                    child: pw.Center(
                        child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.white,
                              borderRadius: pw.BorderRadius.circular(5),
                            ),
                            child: pw.Row(children: [
                              pw.Text('LR No : $lrNo',
                                  maxLines: 2,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold, fontSize: 14),
                                  textAlign: pw.TextAlign.center)
                            ])))),
              ])),
          pw.SizedBox(height: 20),
          pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Text('From'),
                  pdfFrom(fromAddr1),
                  pw.Text('To'),
                  pdfFrom(toAddr1),
                  pw.Text('Truck No'),
                  pdfFrom(vehicleNo),
                  pw.Text('Date'),
                  pdfFrom(docDate),
                ],
              )),
          pw.SizedBox(height: 20),
          pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Text('Consignor'),
                  pdfFrom(fromTrdName),
                  pw.Text('Party GSTIN'),
                  pdfFrom(fromGstin),
                ],
              )),
          pw.SizedBox(height: 20),
          pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Text('Consignee'),
                  pdfFrom(toTrdName),
                  pw.Text('Party GSTIN'),
                  pdfFrom(toGstin),
                ],
              )),
          pw.SizedBox(height: 20),
          pw.Container(
            height: 50,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Center(child: pw.Text('No of\nPkg', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 7,
                    child: pw.Center(child: pw.Text('Contents', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 4,
                    child: pw.Center(child: pw.Text('Actual Wt', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 4,
                    child: pw.Center(child: pw.Text('Charged Wt', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 3,
                    child: pw.Center(child: pw.Text('Rate', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 4,
                    child: pw.Center(child: pw.Text('Total Freight', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 4,
                    child: pw.Center(child: pw.Text('Freight Paid\nin Advance', textAlign: pw.TextAlign.center))
                ),
                pw.VerticalDivider(color: PdfColors.black, width: 1),
                pw.Expanded(
                    flex: 4,
                    child: pw.Center(child: pw.Text('Freight to pay', textAlign: pw.TextAlign.center))
                ),
              ]
            )
          ),
          pw.Expanded(
            child: pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1)
                ),
                child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                          flex: 2,
                          child: pw.Center(child: pw.Text('$quantity $qtyUnit $productName', maxLines: 10 ,textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 7,
                          child: pw.Center(child: pw.Text(hsnCode, maxLines: 10 ,textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                      pw.VerticalDivider(color: PdfColors.black, width: 1),
                      pw.Expanded(
                          flex: 4,
                          child: pw.Center(child: pw.Text('', maxLines: 10, textAlign: pw.TextAlign.center))
                      ),
                    ]
                )
            )
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                children: [
                  pw.SizedBox(
                    height: 30
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5),
                    child: pw.Text('Signature')
                  )
                ],
              ),
              pw.SizedBox(width: 20),
            ],
          )
        ]); // Center
      })); // Page

  final List<int> bytes = await pdf.save();

  // Trigger the file download
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'invoice.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}

//custom pdf from
pdfFrom(String txt) {
  return pw.Expanded(
    child: pw.Container(
        padding: const pw.EdgeInsets.all(5),
        decoration: const pw.BoxDecoration(
            border: pw.TableBorder(
                bottom: pw.BorderSide(
                    color: PdfColorCmyk.fromRgb(0, 0, 0.4164),
                    style: pw.BorderStyle.dotted))),
        child:
            pw.Text(txt, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
  );
}
