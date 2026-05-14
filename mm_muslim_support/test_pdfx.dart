import 'package:pdfx/pdfx.dart';

void main() {
  PdfView(
    controller: PdfController(document: PdfDocument.openAsset('')),
    onPageChanged: (page) {},
    onDocumentLoaded: (doc) {},
  );
}
