import 'package:flutter/material.dart';
import 'package:menu_admin/models/pdf_export.dart';
import 'package:printing/printing.dart';

class PdfViewPage extends StatelessWidget {
  final String jsonString;

  const PdfViewPage({Key? key, required this.jsonString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú en PDF'),
      ),
      body: PdfPreview(
        build: (format) => generatePdf(jsonString),
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
