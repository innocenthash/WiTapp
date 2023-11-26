import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:quiestce/models/employe.dart';

class AfficheCv extends StatefulWidget {
  final Employe employe;
  const AfficheCv({super.key, required this.employe});

  @override
  State<AfficheCv> createState() => _AfficheCvState();
}

class _AfficheCvState extends State<AfficheCv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        pdfData: widget.employe.pdfcv,
        enableSwipe: true,
        // swipeHorizontal: false,
        // autoSpacing: false,
        // pageFling: false,
        onRender: (pages) {
          // Do something when rendering is done
        },
        onError: (error) {
          // Handle error
        },
        onPageError: (page, error) {
          // Handle page error
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // Do something when the PDFView is created
        },
        // onPageChanged: (int page, int total) {
        //   // Do something when page changes
        // },
      ),
    );
  }
}
