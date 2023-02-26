import 'package:doctor_prescription/components/detail_row.dart';
import 'package:flutter/material.dart';

class PatientProfileCard extends StatelessWidget {
  final String? email;
  final String? name;
  final String? gender;
  final String? age;

  PatientProfileCard({this.email, this.name, this.gender, this.age});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/patient.png',
                    width: 80.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          title: 'Name',
                          data: this.name,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DetailRow(
                        title: 'Email',
                        data: this.email,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          title: 'Gender',
                          data: this.gender,
                        ),
                      ),
                      Expanded(
                        child: DetailRow(
                          title: 'DOB',
                          data: age,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
