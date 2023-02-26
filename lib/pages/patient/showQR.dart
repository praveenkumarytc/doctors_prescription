import 'package:doctor_prescription/components/app_bar.dart';
import 'package:doctor_prescription/components/drawer.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    // final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PatientAppBar(
        title: 'Show QR',
      ),
      drawer: const PatientDrawer(),
      body: Consumer<FirebaseServices>(
        builder: (context, details, child) {
          var dataString = [
            details.userDetail!.name,
            details.userDetail!.email,
            details.userDetail!.gender,
            details.userDetail!.dob,
            details.userDetail!.height,
            details.userDetail!.weight,
          ];
          return Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100.0),
                QrImage(
                  data: dataString.join(','),
                  version: QrVersions.auto,
                  size: 320.0,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
