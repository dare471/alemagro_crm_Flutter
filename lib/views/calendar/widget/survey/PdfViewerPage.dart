import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  final String file;

  PdfViewerPage({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Акт осмотра"),
      ),
      body: PDFView(
        filePath: file,
      ),
    );
  }
}
