import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_prescription/components/itemCard.dart';
import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctor_prescription/pages/doctor/components/dashboard/patient_card.dart';
import 'package:doctor_prescription/pages/doctor/components/dashboard/profile_card.dart';
import 'package:doctor_prescription/pages/doctor/components/drawer.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  _fetchUsersDetail() async {
    Provider.of<FirebaseServices>(context, listen: false).fetchUsersDetail();
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchUsersDetail();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
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
      body: Consumer<FirebaseServices>(
        builder: (context, details, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: details.userDetail == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
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
                    DoctorProfileCard(
                      email: details.userDetail!.email,
                      name: details.userDetail!.name,
                      gender: details.userDetail!.gender,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Patients',
                        style: kDashboardTitleTextStyle,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Users').doc(uid).collection('patients').snapshots(),
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
                            return PatientItemCard(
                              email: data['email'],
                              age: data['dob'],
                              gender: data['gender'],
                              name: data['name'],
                            );
                          }).toList());
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: FutureBuilder(
                    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    //       if (snapshot.hasError || (2 > 3)) {
                    //         return Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Image.asset(
                    //                   'assets/icons/patient.png',
                    //                   width: 128.0,
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 20.0,
                    //                 ),
                    //                 const Text(
                    //                   'No Patients Found.',
                    //                   style: TextStyle(
                    //                     fontSize: 21.0,
                    //                     fontWeight: FontWeight.w600,
                    //                     color: Colors.black87,
                    //                   ),
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 10.0,
                    //                 ),
                    //                 const Text(
                    //                   'Looks like you don\'t have any patients. Click the add button to add more patients.',
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                     fontSize: 16.0,
                    //                     fontWeight: FontWeight.w600,
                    //                     color: Colors.black45,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //       if (3 > 2) {
                    //         return ListView.builder(
                    //           itemCount: 3,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             return PatientItemCard(
                    //               email: 'email.com',
                    //               age: '45 Years',
                    //               gender: 'Male',
                    //               name: 'Praveen',
                    //             );
                    //           },
                    //         );
                    //       }
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
        ),
      ),
    );
  }
}
