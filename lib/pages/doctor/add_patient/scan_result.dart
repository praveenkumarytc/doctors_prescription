import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/components/patient/add_patient/detail_profile_card.dart';
import 'package:doctor_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctor_prescription/pages/doctor/components/drawer.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResultPageQR extends StatefulWidget {
  final String qrText;

  const ScanResultPageQR({super.key, required this.qrText});
  @override
  _ScanResultPageQRState createState() => _ScanResultPageQRState();
}

class _ScanResultPageQRState extends State<ScanResultPageQR> {
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    List<String> qrData = widget.qrText.split(',');
    return Scaffold(
        appBar: DoctorAppBar(
          title: 'Scan Result',
        ),
        drawer: DoctorAppDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PatientDetailProfileCard(
                  email: qrData[1],
                  name: qrData[0],
                  gender: qrData[2],
                  height: qrData[4],
                  weight: qrData[5],
                  age: qrData[3],
                ),
                const SizedBox(height: 25.0),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () {
                          addPatienst(qrData[1], qrData[0], qrData[2], qrData[3], qrData[4], qrData[5]);
                        },
                        // icon: Icon(Icons.add),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add),
                              Text(
                                'Add as Patient',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10.0,
                ),
                _message == ''
                    ? SizedBox()
                    : Text(
                        '$_message',
                        style: TextStyle(
                          color: _messageColor,
                          fontSize: 14.0,
                        ),
                      )
              ],
            )));
  }

  addPatienst(email, name, gender, dob, height, weight) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await Provider.of<FirebaseServices>(context, listen: false).addPatient(context, email, name, gender, dob, height, weight, uid);
    var snackBar = SnackBar(backgroundColor: Colors.teal, content: Text('$name Added as patient'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
}
