// ignore_for_file: library_private_types_in_public_api

import 'package:doctor_prescription/components/app_bar.dart';
import 'package:flutter/material.dart';

class PatientScanResult extends StatelessWidget {
  String text;

  PatientScanResult({super.key, required this.text});
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: 'Scan Results'),
      body: Container(
        child: Text(text),
      ),
    );
  }
}
