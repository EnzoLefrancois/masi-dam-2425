import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/scanner_widget.dart';

class IsbnScannerScreen extends StatefulWidget {
  const IsbnScannerScreen({super.key});

  @override
  State<IsbnScannerScreen> createState() => _IsbnScannerScreenState();
}

class _IsbnScannerScreenState extends State<IsbnScannerScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ScannerWidget(
            onScan: onScan,
          ),
        ),
      ],
    );
  }

  Future<void> onScan(Barcode barcode) async {
    // Loading dialog
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertCtx) {
          return AlertDialog(
            content: Text(barcode.code!),
          );
        });

    Navigator.pop(context);
  }
}