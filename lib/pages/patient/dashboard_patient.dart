import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/components/app_bar.dart';
import 'package:doctor_prescription/components/drawer.dart';
import 'package:doctor_prescription/components/itemCard.dart';
import 'package:doctor_prescription/components/profile_card.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  _fetchUsersDetail() async {
    Provider.of<FirebaseServices>(context, listen: false).fetchUsersDetail();
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    _fetchUsersDetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Consumer<FirebaseServices>(
          builder: (context, details, child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: details.userDetail == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
                        email: details.userDetail!.email,
                        name: details.userDetail!.name,
                        gender: details.userDetail!.gender,
                        age: details.userDetail!.dob,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Prescriptions',
                          style: kDashboardTitleTextStyle,
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Users').doc(uid).collection('medicines').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Error occured');
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading...');
                            } else if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ListView(
                                children: snapshot.data!.docs.map((data) {
                              return ItemCard(
                                avatarImage: const NetworkImage('https://firebasestorage.googleapis.com/v0/b/doctor-s-prescription.appspot.com/o/Medicines%2FBENADRYL?alt=media&token=2161cc44-e700-479e-8424-669b1251ec07'),
                                backgroundColor: Colors.green.shade200,
                                title: data['medicine_name'] ?? '',
                                content: [
                                  'Dosage: ${data['dosage']}',
                                  'Category: ${data['category']}',
                                ],
                              );
                            }).toList());
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
