import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scanner/app/modules/result/result_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isScanned = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("二维码扫描"),
      ),
      body: Center(
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }

  void _pushResultPage(Barcode scanData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(data: scanData)),
    ).then((_) async {
      await _controller!.resumeCamera();
      _isScanned = false;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isScanned) return;

      _isScanned = true;
      await _controller!.pauseCamera();
      _pushResultPage(scanData);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }
}
