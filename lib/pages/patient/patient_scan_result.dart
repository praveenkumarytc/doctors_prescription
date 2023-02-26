// ignore_for_file: library_private_types_in_public_api

import 'package:doctor_prescription/components/app_bar.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientScanResult extends StatefulWidget {
  String text;

  PatientScanResult({super.key, required this.text});

  @override
  State<PatientScanResult> createState() => _PatientScanResultState();
}

class _PatientScanResultState extends State<PatientScanResult> {
  bool _isLoading = false;

  TextEditingController controller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: 'Scan Results'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 40,
          child: ElevatedButton(
              onPressed: () {
                namecontroller.text = controller.text.length < 10 ? controller.text : controller.text.substring(0, 10);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Add Medicine'),
                    content: SingleChildScrollView(
                      child: Column(children: [
                        TextField(
                          controller: namecontroller,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            helperText: '',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                            filled: true,
                            labelText: 'Name',
                          ),
                        ),
                        TextField(
                          controller: dosageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            helperText: '',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                            filled: true,
                            labelText: 'Dosage in mg',
                          ),
                        ),
                        TextField(
                          controller: categoryController,
                          // keyboardType: TextInputType.,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                            filled: true,
                            helperText: '',
                            counterText: '',
                            labelText: 'category name',
                          ),
                        )
                      ]),
                    ),
                    elevation: 5,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          addMedicine(namecontroller.text, dosageController.text, categoryController.text);
                          var snackBar = SnackBar(backgroundColor: Colors.teal, content: Text('${namecontroller.text} Added..'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context, 'Update');
                        },
                        child: const Text('Add Prescibed Medicine'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Add Medicine',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Edit Medicine before uploading',
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              TextField(
                controller: controller,
                scrollPhysics: const BouncingScrollPhysics(),
                maxLines: 50,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addMedicine(name, dosage, category) async {
    await Provider.of<FirebaseServices>(context, listen: false).addMedicine(context, name, dosage, category);
    Navigator.pop(context);
  }
}
