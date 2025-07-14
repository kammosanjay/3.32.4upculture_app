import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:upculture/resources/my_string.dart';

import '../resources/my_color.dart';
import '../resources/my_font.dart';
import '../resources/my_font_weight.dart';

class PdfxViewScreen extends StatefulWidget {
  String fileName;
  String pdfUrl;

  PdfxViewScreen({Key? key, required this.fileName, required this.pdfUrl})
      : super(key: key);

  @override
  State<PdfxViewScreen> createState() => _PdfxViewScreenState();
}

class _PdfxViewScreenState extends State<PdfxViewScreen> {
  // PdfControllerPinch? pdfPinchController;
  File? pdfFile;

  var _controller;

  @override
  void initState() {
    // TODO: implement initState
    pdfFile = null;
    if (widget.fileName.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        await createFileOfPdfUrl();
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          pdfFile != null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PDFView(
                      filePath: pdfFile!.path,
                      enableSwipe: true,
                      swipeHorizontal: false, // Enables vertical scrolling
                      autoSpacing: true, // Ensures space between pages
                      pageSnap: true, // Prevents automatic snapping
                      pageFling: true, // Prevents fast page snapping
                      fitPolicy:FitPolicy.BOTH,// Adjusts fit for both width and height
                      // **Adds margin between pages**
                      onRender: (pages) {
                        setState(() {
                          // isReady = true;
                        });
                      },
                      onError: (error) {
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        // _controller.complete(pdfViewController);
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                      },
                      preventLinkNavigation: false,
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      MyString.waitPDF,
                      style: TextStyle(
                          color: MyColor.color4F4C4C,
                          fontSize: 14,
                          fontFamily: MyFont.roboto,
                          fontWeight: MyFontWeight.regular),
                    ),
                  ],
                ))
        ],
      ),
    ));
  }

  ///
  ///
  ///
  Future<File> createFileOfPdfUrl() async {
    pdfFile = null;
    Completer<File> completer = Completer();
    log('PDF_File _Name Server- ${widget.fileName}');
    log("Start download file from internet!");
    try {
      final filename = widget.fileName;
      var dir = await getApplicationSupportDirectory();

      log("PDF_File CompletePath- ${dir.path}/$filename");

      if (await File("${dir.path}/$filename").exists()) {
        pdfFile = File("${dir.path}/$filename");
        setState(() {});
        completer.complete(pdfFile);
        // pdfPinchController = PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path),);
        log('PDF_File Already Exists');
        setState(() {});
      } else {
        print("else");
        var request = await HttpClient().getUrl(Uri.parse(widget.pdfUrl));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);

        print(request.contentLength);

        File file = File("${dir.path}/$filename");
        log(file.path);
        await file.writeAsBytes(bytes, flush: true);
        pdfFile = file;
        setState(() {});
        completer.complete(file);
        // pdfPinchController = PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path),);
        log('PDF_File NOT Exists');
        setState(() {});
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return completer.future;
  }

  // ///
  // ///
  // ///
  // headerWidget() {
  //   return Container(
  //     height: Get.height * 0.14,
  //     width: Get.width,
  //     alignment: Alignment.center,
  //     padding: const EdgeInsets.symmetric(horizontal: 15),
  //     decoration: BoxDecoration(
  //         image: DecorationImage(
  //             image: serviceHeaderBg,
  //             fit: BoxFit.fill
  //         )
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 15.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //
  //           InkWell(
  //             onTap: (){
  //               Get.back();
  //             },
  //             child: Image(
  //               image: backArrow,
  //               height: 40,
  //               width: 40,
  //             ),
  //           ),
  //
  //           Flexible(
  //             child: Text(
  //               widget.fileName,
  //               style: GoogleFonts.poppins(
  //                   color: Colors.white,
  //                   fontWeight: MyFontWeight.semiBold,
  //                   fontSize: 16
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(
  //             height: 40,
  //             width: 40,
  //           )
  //           /*InkWell(
  //             onTap: (){
  //               Get.offAll(() => const HomeScreen());
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(50),
  //                   border: Border.all(color: Colors.white)
  //               ),
  //               child: Text(
  //                 'Skip',
  //                 style: GoogleFonts.poppins(
  //                     color: Colors.white,
  //                     fontWeight: MyFontWeight.semiBold,
  //                     fontSize: 11
  //                 ),
  //               ),
  //             ),
  //           )*/
  //         ],
  //       ),
  //     ),
  //
  //   );
  // }
}
