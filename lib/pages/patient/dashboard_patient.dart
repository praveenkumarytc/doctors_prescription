import 'package:doctor_prescription/components/app_bar.dart';
import 'package:doctor_prescription/components/drawer.dart';
import 'package:doctor_prescription/components/itemCard.dart';
import 'package:doctor_prescription/components/profile_card.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Update Medicines
    // Provider.of<PatientBloc>(context, listen: false).updateMedicines();
  }

  @override
  Widget build(BuildContext context) {
    // final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    // final AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      appBar: PatientAppBar(title: 'Dashboard'),
      drawer: PatientDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PATIENT_SCAN_PRESCRIPTION);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Your Profile',
                style: kDashboardTitleTextStyle,
              ),
            ),
            PatientProfileCard(
              email: 'dpsingh877@gmail.com',
              name: 'Praveen Kumar',
              gender: 'Male',
              age: '22 Years',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Prescriptions',
                style: kDashboardTitleTextStyle,
              ),
            ),
            ItemCard(
              avatarImage: const NetworkImage('https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/Medicines%2FBENADRYL?alt=media&token=2161cc44-e700-479e-8424-669b1251ec07'),
              backgroundColor: Colors.green.shade200,
              title: 'Benadryl DR Syrup 100ml',
              content: [
                'Dosage: 100ml',
                'Category: Cough and Cold'
              ],
            ),
            ItemCard(
              avatarImage: const NetworkImage('https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/Medicines%2FCROCIN?alt=media&token=b373b505-b015-420c-ba28-d59e6398a1a9'),
              backgroundColor: Colors.green.shade200,
              title: 'Crocin 650mg Tablet',
              content: [
                'Dosage: 650mg',
                'Category: Fever'
              ],
            )
          ],
        ),
      ),
    );
  }
}
