import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/models/doctor.dart';
import 'package:doctor_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctor_prescription/pages/doctor/components/dashboard/patient_card.dart';
import 'package:doctor_prescription/pages/doctor/components/dashboard/profile_card.dart';
import 'package:doctor_prescription/pages/doctor/components/drawer.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(title: 'Dashboard'),
      drawer: DoctorAppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(DOCTOR_SCAN_QR);
        },
        heroTag: 'addPatient',
        tooltip: 'Add a Patient',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
            DoctorProfileCard(
              email: 'dpsingh877@gmail.com',
              name: 'Praveen Kumar',
              gender: 'Male',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Patients',
                style: kDashboardTitleTextStyle,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError || (2 > 3)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/patient.png',
                              width: 128.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              'No Patients Found.',
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              'Looks like you don\'t have any patients. Click the add button to add more patients.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (3 > 2) {
                    return ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return PatientItemCard(
                          email: 'email.com',
                          age: '45 Years',
                          gender: 'Male',
                          name: 'Praveen',
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
