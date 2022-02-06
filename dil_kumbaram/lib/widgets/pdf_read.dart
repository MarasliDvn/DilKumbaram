import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOku extends StatefulWidget {
  final String url;
  const PdfOku({Key? key, required this.url}) : super(key: key);

  @override
  _PdfOkuState createState() => _PdfOkuState();
}

class _PdfOkuState extends State<PdfOku> {
  String remotePDFpath = "";

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final url = widget.url;
      final fileName = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception("Error downloading pdf file!");
    }

    return completer.future;
  }

  int? pages = 0;
  int? currentPage = 5;
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      widget.url,
    );
  }
}
