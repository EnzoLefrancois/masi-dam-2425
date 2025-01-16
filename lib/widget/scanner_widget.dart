import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerWidget extends StatefulWidget {

  final Function(Barcode) onScan;

  const ScannerWidget({super.key, required this.onScan});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {

  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  Barcode? barcode;

  bool isFlashOn = false;
  bool isCameraBack = true;

  @override
  void initState() {
    if(controller != null) {
      controller!.resumeCamera();
    }

    super.initState();
  }



  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.stopCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildQrView(context);
  }

  Widget buildQrView(BuildContext context) =>
      QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderWidth: 5,
          borderRadius: 7.0,
          cutOutHeight: 225,
          cutOutWidth: 225,
          borderLength: 10,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;

    });
    controller.scannedDataStream.listen((barcode) async {
      // Avoid scanning the same code in a loop
      if(this.barcode == null || this.barcode!.code != barcode.code) {
        this.barcode = barcode;
        Timer(const Duration(seconds: 4), () {this.barcode = null;});

        if(isFlashOn) {
          controller.toggleFlash();
        }
        widget.onScan(barcode);
      }
    });

    controller.pauseCamera();
  }
}
