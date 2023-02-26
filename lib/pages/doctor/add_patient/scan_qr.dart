import 'package:doctor_prescription/models/doctor.dart';
import 'package:doctor_prescription/pages/doctor/add_patient/scan_result.dart';
import 'package:doctor_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctor_prescription/pages/doctor/components/drawer.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  Barcode? qrText;
  GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void closeQr() {
    controller?.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      scanSuccess(qrText!.code);
    });
  }

  void scanSuccess(String? scanData) {
    dispose();
    controller!.dispose();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPageQR(qrText: scanData!),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(
        title: 'Add Patient',
      ),
      drawer: DoctorAppDrawer(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(borderRadius: 10, borderColor: Colors.blueAccent, borderLength: 30, borderWidth: 10, cutOutSize: 300),
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Hero(
                  tag: 'addPatient',
                  child: Text(
                    'Place the QR code in the box.',
                    style: TextStyle(color: Colors.white, fontSize: 21.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
