import 'dart:io';
import 'package:alem_application/views/calendar/widget/survey/PdfViewerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfTableCreator extends StatefulWidget {
  @override
  _PdfTableCreatorState createState() => _PdfTableCreatorState();
}

class _PdfTableCreatorState extends State<PdfTableCreator> {
  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Table Creator'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                buildPdf();
                await savePdf();
              },
              child: Text('Create PDF with Table'),
            ),
            ElevatedButton(
              onPressed: () async {
                buildPdf();
                await delete();
              },
              child: Text('delete pdf '),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buildPdf() async {
    final ByteData image = await rootBundle.load('assets/logo.png');

    Uint8List imageData = (image).buffer.asUint8List();

    // final netimage = await networkImage('https://alemagro.com/img/logo.png');
    pdf.addPage(pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1.0, color: PdfColors.amber400),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.DefaultTextStyle(
                    style: const pw.TextStyle(color: PdfColors.blue),
                    child: pw.Column(
                      children: [
                        pw.Text('Республика Казахстан, 0500000,'),
                        pw.Text('г.Алматы, ул.Абылай хана 135,'),
                        pw.Text('БЦ "White Tower"')
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 150.0,
                    height: 50.0,
                    child: pw.Image(pw.MemoryImage(imageData)),
                  ),
                  pw.DefaultTextStyle(
                    style: const pw.TextStyle(
                      color: PdfColors.blue,
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text('+7 (727) 355 99 77',
                            style: pw.TextStyle(font: pw.Font.times())),
                        pw.Text('office@alemagro.com'),
                        pw.Text('https://alemagro.com')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.Text(
              'Hello world!',
              style: pw.TextStyle(
                fontSize: 25,
              ),
            ),
          ]);
        }));
  }

  Future<void> delete() async {
    try {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example_table.pdf");
      if (await file.exists()) {
        await file.delete();
        print('File deleted');
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<void> savePdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example_table.pdf");
    await file.writeAsBytes(await pdf.save());
    print(file);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(
          file: file.path,
        ),
      ),
    );
  }
}
